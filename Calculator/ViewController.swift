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
    var constantPresent: Bool = false
    
    var brain = CalculatorBrain()
    
    //Append a digit to the top of the stack
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    //Perform a mathematical operation
    @IBAction func operate(sender: UIButton) {
        
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
    
    //Add the key to the top of the stack
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }
        else {
            displayValue = 0
        }
    }
    
    //Format a double value from the displayed string
    //If this happens to be the Pi character than we
    //return the pi constant
    var displayValue: Double {
        get {
            
            if(display.text! == "π")
            {
                return M_PI
            }
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    //Reset the app to its orginal state
    @IBAction func clearAll(sender: UIButton) {
        //operandStack.removeAll(keepCapacity: false)
        lblHistory.text = ""
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false;
    }
    
    //Add to the history label text box
    func appendHistory(newString: String ) {
        lblHistory.text = lblHistory.text! + newString
    }
    
    func appendEquals()
    {
        lblHistory.text = lblHistory.text! + "="
    }
    
    func isConstant(newString: String) -> Bool
    {
        switch newString {
        case "π": return true
        default: return false
        }
    }
    
   
}

