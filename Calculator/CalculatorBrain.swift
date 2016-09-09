//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ana Perez on 9/7/16.
//  Copyright © 2016 Ana Perez. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double, Double)->Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = Array<Op>()
    
    //var knownOps = [String:Op]() //another way to initialize
    private var knownOps = Dictionary<String, Op>()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("−", {$1 - $0 }))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("÷", {$1 / $0 }))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", {sin($0)}))
        learnOp(Op.UnaryOperation("cos", {cos($0)}))
        learnOp(Op.UnaryOperation("tan", {tan($0)}))
       
    }
    private func evaluate(ops: [Op])->(result:Double?, remainingOps:[Op]) {
        if !ops.isEmpty {
            var remainingOps = ops //it doesn't really copy it, its just a pointer
            let op = remainingOps.removeLast() //here it does copy
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvalutation = evaluate(remainingOps)
                if let operand = operandEvalutation.result {
                    return (operation(operand), operandEvalutation.remainingOps)
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
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        
        return result
    }
    func pushOperand(operand: Double)->Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func performOperation(symbol: String)-> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}