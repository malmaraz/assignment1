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
    var brain = CalculatorBrain()
    
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

    @IBAction func setMem(sender: UIButton) {
        brain.variableValues["M"] = displayValue
    }
    
    @IBAction func getMem(sender: UIButton) {
        if let val = brain.variableValues["M"] {
            display.text = "\(val)"
        }
    }
    
    @IBAction func enter() {
        userIsTypingNumber = false
        usedDecimal = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
            history.text = brain.description + " ="
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        } set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            userIsTypingNumber = false
        }
    }
    @IBAction func clear() {
        brain.clearStack()
        display.text = "0"
        userIsTypingNumber = false
        usedDecimal = false
        brain.variableValues.removeAll()
    }
}


