//
//  ViewController.swift
//  Calculator
//
//  Created by Martin Almaraz on 9/9/16.
//  Copyright © 2016 Martin Almaraz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    var userIsTypingNumber: Bool = false
    var usedDecimal: Bool = false
    var operandStack = Array<Double>()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "π" {
            display.text = "\(M_PI)"
            return
        }
        if digit == "." && usedDecimal {
            return
        } else if digit == "." && !usedDecimal {
            usedDecimal = true
        }
        if userIsTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTypingNumber = true
        }
        print("digit = \(digit)")
    }

    @IBAction func enter() {
        userIsTypingNumber = false
        usedDecimal = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
        
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let op = sender.currentTitle!
        if userIsTypingNumber {
            enter()
        }
        switch op {
        case "×": performOperation( op, operation: { $0 * $1 } )
        case "÷": performOperation( op, operation: { $0 / $1 } )
        case "+": performOperation( op, operation: { $0 + $1 } )
        case "-": performOperation( op, operation: { $0 - $1 } )
        case "√": performOperation( op, operation: { sqrt($0) } )
        case "sin": performOperation( op, operation: { sin($0) } )
        case "cos": performOperation( op, operation: { cos($0) } )
        default: break
        }
    }
    
    private func performOperation(op: String, operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            let f = operandStack.removeLast()
            let l = operandStack.removeLast()
            displayValue = operation(f, l)
            history.text = "\(f) \(op) \(l)"
            enter()
        }
    }
    
    private func performOperation(op:String, operation: Double -> Double) {
        if operandStack.count >= 1 {
            let f = operandStack.removeLast()
            displayValue = operation(f)
            history.text = "\(op)\(f)"
            enter()
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        } set {
            display.text = "\(newValue)"
            userIsTypingNumber = false
        }
    }
    @IBAction func clear() {
        operandStack.removeAll()
        display.text = "0"
        userIsTypingNumber = false
        usedDecimal = false
    }
}


