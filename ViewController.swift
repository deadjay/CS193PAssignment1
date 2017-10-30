//
//  ViewController.swift
//  CS193PAssignment1
//
//  Created by Artem Alekseev on 30/10/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

	// Outlets
	@IBOutlet weak var display: UILabel!

	// MARK: - Construction

	// MARK: - ViewController Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	// MARK: - Actions

	@IBAction func touchDigit(_ sender: UIButton) {
		guard let digit = sender.currentTitle else { return }
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
		userIsInTheMiddleOfTyping = false
		guard let mathematicalSymbol = sender.currentTitle else { return }
		switch mathematicalSymbol {
		case "π":
			displayValue = Double.pi
		case "√":
			displayValue = sqrt(displayValue)
		default:
			break
		}

	}


}

