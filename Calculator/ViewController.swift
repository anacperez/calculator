//
//  ViewController.swift
//  Calculator
//
//  Created by Ana Perez on 8/31/16.
//  Copyright © 2016 Ana Perez. All rights reserved.
//

import UIKit
import Darwin

//definition of a class
class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsIntheMiddleOfTyping = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsIntheMiddleOfTyping {
            display.text = display.text! + digit
            print("digit = \(digit)")
        }
        else {
            display.text = digit
            userIsIntheMiddleOfTyping = true
        }
        
    }
    @IBAction func operate(sender: UIButton) {
        if userIsIntheMiddleOfTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else{
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsIntheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else{
            displayValue  = 0
        }
    }
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsIntheMiddleOfTyping = false
        }
    }
}

