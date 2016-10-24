//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by martin almaraz on 9/28/16.
//  Copyright © 2016 Martin Almaraz. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Var(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Var(let variable):
                    return "\(variable)"
                }
            }
        }
    }
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    var program: PropertyList {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    typealias PropertyList = AnyObject
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvalutaion = evaluate(remainingOps)
                if let operand = operandEvalutaion.result {
                    return (operation(operand), operandEvalutaion.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evalutation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evalutation.result {
                        return (operation(operand1, operand2), op2Evalutation.remainingOps)
                    }
                }
            case .Var(let variable):
                if let val = knownOps[variable] {
                    remainingOps.append(val)
                    return evaluate(remainingOps)
                } else {
                    return (nil, ops)
                }
            }
        }
        return (nil, ops)
    }
    
    var variableValues = [String:Double]()
    
    var description: String {
        get {
            return brainToString()
        }
    }
    
    private func brainToString(ops: [Op]) -> (result: String?, remain: [Op])
    {
        if !ops.isEmpty {
            var remaining = ops
            let op = remaining.removeLast()
            switch op {
            case .Operand(let operand):
                let opString = brainToString(remaining)
                return ("\(opString) \(operand)", remaining)
            case .UnaryOperation(let operation, _):
                let opString = brainToString(remaining)
                return ("\(opString) \(operation)(\(remaining.removeLast()))", remaining)
            case .BinaryOperation(let operation, _):
                let opString = brainToString(remaining)
                return ("\(opString) \(operation) \(remaining.removeLast())", remaining)
            case .Var(let variable):
                let opString = brainToString(remaining)
                return ("\(opString) \(variable)", remaining)
            }
        }
        return (nil, ops)
    }
    
    private func brainToString() -> String {
        let (ret, _) = brainToString(opStack)
        return ret!
    }
    
    func pushOperand(symbol: String) -> Double?
    {
        opStack.append(Op.Var(symbol))
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result!) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() { opStack.removeAll() }
    
    private func describe(_ ops: [Op], order: Int = 0) -> (description: String, remainingOps: [Op]) {
        var currOps = ops
        
        if !currOps.isEmpty {
            let op = currOps.removeLast()
            
            switch op {
                
            case .operand:
                return (op.description, currentOps)
            case .variable:
                return (op.description, currentOps)
            case .constant:
                return (op.description, currentOps)
            case .unaryOperation:
                let (operandDesc, remainingOps) = describe(currentOps)
                return ( op.description+"("+operandDesc+")", remainingOps)
            case .binaryOperation(_, let precedence, _, _):
                let (operandDesc1, remainingOps1) = describe(currentOps, currentOpPrecedence: precedence)
                let (operandDesc2, remainingOps2) = describe(remainingOps1, currentOpPrecedence: precedence)
            }
        }
        return ("?", currOps)
    }
    }
