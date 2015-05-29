//
//  ViewController.swift
//  Calculator
//
//  Created by Brian Thomas Mikinski on 2/16/15.
//  Copyright (c) 2015 Brian Thomas Mikinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Question mark here says it is an optional but always unwrap it
    //Options can be nil, or point to type of declaration
    //Implicitly unwrapped optional
    //Useful mainly only for things that get set early and usually don't change
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var IsDecimalPresent: Bool = false
    
    var brain = CalculatorBrain()
    
    /**
    Append a digit to the top of the stack.
    
    :param: sender One of the 10 digit buttons.
    */
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        saveOperand(digit)
        
        //Handle "." floating point numbers
        if ( digit == ".") {
            if (!IsDecimalPresent) {
                appendOperandCharacter(digit)
                IsDecimalPresent = true
                userIsInTheMiddleOfTypingANumber = true
            }
        //Handle constants and variables
        } else if let constant = constant(digit) {
            
            if(userIsInTheMiddleOfTypingANumber)
            {
                if let result = brain.pushOperand(displayValue!) {
                    displayValue = result
                }
                else {
                    displayValue = 0
                }
            }
            
            //let Operand1 = brain.pushOperand(displayValue)
            let Operand2 = brain.pushOperand(constant)
            
            appendOperandCharacter(digit)
            userIsInTheMiddleOfTypingANumber = false
            IsDecimalPresent = false
        //Handle all other types of input
        } else if userIsInTheMiddleOfTypingANumber {
            
            appendOperandCharacter(digit)
            
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    /**
    Add the entered number to the calculator brain stack.
    */
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        IsDecimalPresent = false
        
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
        else {
            displayValue = nil
        }
    }
    
    /**
    Save a variable to the stack.
    
    :param: sender The "m->" button.
    */
    @IBAction func storeVariable(sender: UIButton) {

        var number = NSNumberFormatter().numberFromString(display.text!)
        
        //if number != nil {
            if let result = brain.saveVariableOperand(number!.doubleValue) {
                displayValue = result
            }
        //}
    }
    
    /**
    Get the value of the stored variable.
    
    param: sender The "M" button
    */
    @IBAction func GetStoredVariable(sender: UIButton) {
        
        brain.pushVariableOperand("x")
    }

    
    /**
    Function that takes an operation entered by the user and applies it to the stack.
    
    :param: sender A UI button object that represents an operation.
    */
    @IBAction func operate(sender: UIButton) {
        
        saveOperation(sender.currentTitle!)
        
        println("Current number = \(sender.currentTitle!)")
        
        if userIsInTheMiddleOfTypingANumber {
            
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        
        getDisplayResult()
    }
    
    /**
    Remove the last character that was entered.
    
    :param: sender A button representing the backspace action.
    */
    @IBAction func Backspace(sender: UIButton) {
        
        if (count(display.text!) > 0) {
            
            println("Backspace: last character of operand = \"\(display.text!)\"")
            
            var operand = display.text;
            //.endIndex is one over the last index so you
            let index = operand!.endIndex.predecessor()
            
            println("Backspace: Last indexed character: = \"\(index)")
            
            var lastDigit = operand![index]
            println("Backspace: last character of operand = \"\(lastDigit)\"")
            
            if let constant = constant(String(lastDigit))
            {
                println("Backspace: constant = \"\(lastDigit)\"")
                brain.removeConstant()
            }
            
            display.text = dropLast(display.text!)
            
            if (count(display.text!) > 0) {
                userIsInTheMiddleOfTypingANumber = true
            }
            else {
                userIsInTheMiddleOfTypingANumber = false
            }
            
            if displayValue == nil {
                
            }
        }
    }
    
    /**
    Reset the displayValue, history label, brain stack and calculator brain it their initial values.
    
    :param: sender <#sender description#>
    */
    @IBAction func clearAll(sender: UIButton) {
        
        //Clear the operand stack
        brain.clear()
        
        lblHistory.text = ""
        displayValue = nil
        userIsInTheMiddleOfTypingANumber = false
        IsDecimalPresent = false
    }
    

    /// Format a double value from the displayed string
    /// If this happens to be the Pi character than we
    /// return the pi constant
    var displayValue: Double? {
        get {
            
            if let constant = constant(display.text!) {
                return constant
            } else {
                
                var number = NSNumberFormatter().numberFromString(display.text!)
                
                if number != nil {
                    return number!.doubleValue
                }
                else {
                    return nil
                }
            }
        }
        set {
            
            if(newValue == nil) {
                display.text = " "
            } else {
                display.text = "\(newValue!)"
            }
        }
    }
    
    /**
    Add an "=" sign on to the end of the history label.
    */
    private func appendEquals() {
        lblHistory.text = lblHistory.text! + "="
    }
    
    //Add to the history label text box
    private func appendHistory(newString: String ) {
        //lblHistory.text = lblHistory.text! + newString
        
    }
    
    /**
    Append a digit or constant to the display text.
    
    :param: digit The digit or constant to appaend to the end of the display text.
    */
    private func appendOperandCharacter(digit: String) {
        display.text = display.text! + digit
    }
    
    /**
    Check for a constant variable value
    
    :param: operand The operand to be matched to a value.
    
    :returns: The value of the operand.
    */
    private func constant(operand: String) -> Double? {
        switch operand {
        case "π":
            return M_PI
        default:
            return nil
        }
    }
    
    /**
    Check if a variable is a constant or not.
    
    :param: newString The character to check against a list of constants.
    
    :returns: A boolean value if the function is a constant.
    */
    private func isConstant(newString: String) -> Bool {
        switch newString {
        case "π": return true
        default : return false
        }
    }
    
    /**
    Get an infix display of the calculator brain stack.
    */
    private func getDisplayResult()
    {
        lblHistory.text = brain.description
    }
    
    /**
    Save the operand to the history label.
    
    :param: term The character being saved.
    */
    private func saveOperand(term: String) {
        lblHistory.text = lblHistory.text! + term
    }
    
    /**
    Save an operation to the stack.
    
    :param: term One of the many operators that can be saved to the stack.
    */
    private func saveOperation(term: String) {
        lblHistory.text = "\(lblHistory.text!)\(term) = "
    }
}