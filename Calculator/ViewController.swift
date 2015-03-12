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
    
    var userIsInTheMiddleOfTypingANumber = false
    var floatingPointNumberHasBeenInput = false
    var resetHistory = false
    var constantPresent = false
    
    var operandStack = Array<Double>()
    
    //Append a digit to the top of the stack
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if((display.text!.rangeOfString(".") == nil) || (digit != ".") || (display.text! == "")) {
            
            if userIsInTheMiddleOfTypingANumber {

                if isConstant(display.text!)
                {
                    display.text = "\(displayValue * NSNumberFormatter().numberFromString(digit)!.doubleValue)"
                }
                else
                {
                
                    switch digit {
                
                        case "π": display.text = "\(displayValue * M_PI)"
                        
                        default: display.text = display.text! + digit
                    }
                }
            }
            else {
                
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
            
            appendHistory(digit)
        }
    }
    
    //Reset the app to its orginal state
    @IBAction func clearAll(sender: UIButton) {
        operandStack.removeAll(keepCapacity: false)
        lblHistory.text = ""
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false;
        println("operandStack = \(operandStack)")
        
    }
    
    //Add the key to the top of the stack
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        floatingPointNumberHasBeenInput  = false
        constantPresent = false
        
        operandStack.append(displayValue)
        
        
        //operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    //Perform a mathematical operation
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if !userIsInTheMiddleOfTypingANumber {
            
            appendHistory(operation)
            appendEquals()
        
            switch operation {
                
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $0 / $1 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $0 - $1 }
            case "√": performOperation { sqrt($0) }
            case "sin": performOperation { sin($0) }
            case "cos": performOperation { cos($0) }
            default: break
                
                //          You can do this if you need want to be more verbose
                //        case "×": performOperation({(op1: Double, op2: Double) -> Double in
                //            return op1  * op2
                
            }
            
            resetHistory = true
        }
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
    
    //Execute a function that takes two doubles and outputs
    //another double
    func performOperation(operation: (Double, Double) -> Double ) {
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast()  )
            enter()
        }
    }
    
    //Execute a function that takes one double and outputs
    //a double
    func performOperation(operation: (Double) -> Double ) {
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
}

