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
        saveHistory(digit)
        
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
            //let Operand1 = brain.pushOperand(displayValue)
            let Operand2 = brain.pushOperand(constant)
            
            if(userIsInTheMiddleOfTypingANumber)
            {
                if let result = brain.pushOperand(displayValue) {
                    displayValue = result
                }
                else {
                    displayValue = 0
                }
            }
            
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
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
    }
    
    //Perform a mathematical operation
    @IBAction func operate(sender: UIButton) {
        
        saveHistory(sender.currentTitle!)
        
        println("Current number = \(sender.currentTitle!)")
        
        if userIsInTheMiddleOfTypingANumber {
            
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    //Reset the app to its orginal state
    @IBAction func clearAll(sender: UIButton) {
        
        //Clear the operand stack
        brain.clear()
        
        lblHistory.text = ""
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false;
    }
    
    //Format a double value from the displayed string
    //If this happens to be the Pi character than we
    //return the pi constant
    var displayValue: Double {
        get {
            
            if let constant = constant(display.text!) {
                return constant
            } else {
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    //Add to the history label text box
    private func appendHistory(newString: String ) {
        lblHistory.text = lblHistory.text! + newString
    }
    
    private func appendEquals()
    {
        lblHistory.text = lblHistory.text! + "="
    }
    
    private func appendOperandCharacter(digit: String)
    {
        display.text = display.text! + digit
    }
    
    //Check to see if the variable is a constant or not - PI would be an example of a constant
    private func constant(test: String) -> Double?
    {
        switch test{
        case "π":
            return M_PI
        default:
            return nil
        }
    }
    
    private func isConstant(newString: String) -> Bool
    {
        switch newString {
        case "π": return true
        default: return false
        }
    }
    
    private func saveHistory(term: String)
    {
        lblHistory.text = lblHistory.text! + term
    }
}