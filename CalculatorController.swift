//
//  CalculatorController.swift
//  CS193PAssignment1
//
//  Created by Artem Alekseev on 30/10/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController {

	//MARK: - IBOutlets
	
	@IBOutlet weak var display: UILabel!
	
	// MARK: - Properties
	
	var userIsInTheMiddleOfTyping = false
	var displayValue: Double {
		get {
			if let displayText = display.text,
				let displayTextInDouble = Double(displayText) {
				return displayTextInDouble
			}
			return 0.0
		}
		set {
			display.text = String(newValue)
		}
	}
	
	// MARK: - Private Properties
	
	private var brain = CalculatorBrain()
	private func isLegalFloatingPointNumber(_ digit: String) -> Bool {
		guard digit == ".",
			let contains = display.text?.contains(digit) else {return true}
		
		return !contains
	}

	// MARK: - Actions

	@IBAction func touchDigit(_ sender: UIButton) {
		guard let digit = sender.currentTitle,
			isLegalFloatingPointNumber(digit) else { return }
		
		if userIsInTheMiddleOfTyping {
			if let textCurrentlyInDisplay = display.text {
				display.text = textCurrentlyInDisplay + digit
			}
		} else {
			display.text = digit
			userIsInTheMiddleOfTyping = true
		}
	}

	@IBAction func performOperation(_ sender: UIButton) {
		if userIsInTheMiddleOfTyping {
			brain.setOperand(displayValue)
			userIsInTheMiddleOfTyping = false
		}
		
		if let mathSymbol = sender.currentTitle {
			brain.performOperation(mathSymbol)
		}
		
		if let result = brain.result {
			displayValue = result
		}
	}
}
