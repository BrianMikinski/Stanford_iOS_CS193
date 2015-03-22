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
    
    //Append a digit to the top of the stack
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        saveOperand(digit)
        
        //Handle "." floating point numbers
        if ( digit == ".")
        {
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
    
    //Add the key to the top of the stack
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
    
    //Perform a mathematical operation
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
    
    //Delete the last input item
    @IBAction func Backspace(sender: UIButton) {
        
        if (countElements(display.text!) > 0) {
            
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
            
            if (countElements(display.text!) > 0) {
                userIsInTheMiddleOfTypingANumber = true
            }
            else {
                userIsInTheMiddleOfTypingANumber = false
            }
            
            if displayValue == nil {
                
            }
        }
    }
    
    //Reset the app to its orginal state
    @IBAction func clearAll(sender: UIButton) {
        
        //Clear the operand stack
        brain.clear()
        
        lblHistory.text = ""
        displayValue = nil
        userIsInTheMiddleOfTypingANumber = false
        IsDecimalPresent = false
    }
    
    //Format a double value from the displayed string
    //If this happens to be the Pi character than we
    //return the pi constant
    var displayValue: Double? {
        get {
            
            if let constant = constant(display.text!) {
                return constant
            } else {
                
                var number = NSNumberFormatter().numberFromString(display.text!)?
                
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
    
    private func appendEquals() {
        lblHistory.text = lblHistory.text! + "="
    }
    
    //Add to the history label text box
    private func appendHistory(newString: String ) {
//        lblHistory.text = lblHistory.text! + newString
        
        
    }
    
    private func appendOperandCharacter(digit: String) {
        display.text = display.text! + digit
    }
    
    //Check to see if the variable is a constant or not - PI would be an example of a constant
    private func constant(operand: String) -> Double? {
        switch operand {
        case "π":
            return M_PI
        default:
            return nil
        }
    }
    
    //Check if a variable is a constant or not
    private func isConstant(newString: String) -> Bool {
        switch newString {
        case "π": return true
        default : return false
        }
    }
    
    private func getDisplayResult()
    {
        lblHistory.text = brain.description
    }
    
    private func saveOperand(term: String) {
        lblHistory.text = lblHistory.text! + term
    }
    
    private func saveOperation(term: String) {
        lblHistory.text = "\(lblHistory.text!)\(term) = "
    }
}