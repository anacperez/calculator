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
    
    @IBOutlet weak var display: UILabel! //user input label
    @IBOutlet weak var history: UILabel! //history label
    
    var userTypedDecimalNum = false
    var userIsIntheMiddleOfTyping = false
    var operandStack = Array<Double>()
  
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsIntheMiddleOfTyping {
            if(digit == "." && userTypedDecimalNum == false){
                userTypedDecimalNum = true;
                display.text = display.text! + digit
                history.text! = history.text! + digit
            }
            else if (digit != ".") {
                display.text = display.text! + digit
                history.text! = history.text! + digit
            }
        }
        else {
            display.text = digit
            history.text! = history.text! + digit
            userIsIntheMiddleOfTyping = true
        }
        
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsIntheMiddleOfTyping == false {
            history.text! = history.text! + sender.currentTitle!
            //enter()
        }
        switch operation{
        case"×": performOperation {$0 * $1}
        case"÷": performOperation {$1 / $0}
        case"+": performOperation {$0 + $1}
        case"−": performOperation {$0 - $1}
        case"√": performOperation {sqrt($0)}
        case"sin": performOperation {sin($0)}
        case"cos": performOperation {cos($0)}
        case"∏": showPI()
        default: break
        }
    }
    
    //when user presses C
    @IBAction func clear() {
        userIsIntheMiddleOfTyping = false
        userTypedDecimalNum = false
        display.text! = "0"
        history.text! = " "
        operandStack.removeAll();
    }
    //calculates user input
    private func performOperation(operation: (Double, Double)->Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    //calulates the user input
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    //when user presses the enter button
    @IBAction func enter() {
        userIsIntheMiddleOfTyping = false
        userTypedDecimalNum = false
        operandStack.append(displayValue)
        history.text! = history.text! + " "
    }
    func showPI() {
        displayValue = M_PI
        enter()
    }
    var displayValue: Double{
        get {
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            history.text! = history.text! + "=" + display.text!

        }
    }
}

