//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Brian Thomas Mikinski on 3/14/15.
//  Copyright (c) 2015 Brian Thomas Mikinski. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double ->Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _ ):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //Alternative form of displaying array
    //var opStack = Array<Op>()
    private var opStack = [Op]()
    
    //Alternative form of declaring dictionay
    //var knownOps = Dictionary<String, Op>()
    private var knownOps = [String:Op]()
    
    init()
    {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷"){$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-"){$0 - $1})
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin"){sin($0)})
        learnOp(Op.UnaryOperation("cos"){cos($0)})
        learnOp(Op.UnaryOperation("π") {M_PI * $0})
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: false)
        println("Op Stack = \(opStack)")
    }
    
    //Returning a tuble to hold our evaluation and the remaining operations
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        //There is an error here because it is an array and not a class. That means that the 
        //operation is passed by value as opposed to reference! So it is copied and not referenced
        if !ops.isEmpty {
            
            //Creating a mutable array of ops. Because ops is really "let ops: [Op]" in the method parameters
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
                // "_" underscore means that we aren't passing anything to the function
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() ->Double? {
        //Tuple closure? declare a tuple without a type?
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func removeConstant() {
        opStack.removeLast()
        println("Op Stack = \(opStack)")
        opStack.removeLast()
        println("Op Stack = \(opStack)")
    }
    
    //Function used to print debug values to the command line
    func peek(debugValue: Any) -> Any{
        
        println("[peek] \(debugValue)")
        
        return debugValue
    }
}