//
//  CalculatorBrain.swift
//  CS193PAssignment1
//
//  Created by Artem Alekseev on 07/02/2018.
//  Copyright © 2018 Artem Alekseev. All rights reserved.
//

import UIKit


private var descriptionText = ""

func changeSign(operand: Double) -> Double {
	return -operand
}

func add(operator1: Double, operator2: Double) -> Double {
	return operator1 + operator2
}

func subtract(operator1: Double, operator2: Double) -> Double {
	return operator1 - operator2
}

func multiply(operator1: Double, operator2: Double) -> Double {
	return operator1 * operator2
}

func divide(operator1: Double, operator2: Double) -> Double {
	return operator1 / operator2
}

private func findPercentage(_ operand: Double) -> Double {
	return operand * 0.01
}

struct CalculatorBrain {
	var resultIsPending = false
	
	var description = ""
	
	var transitionalDescription = (0.0, "", "") {
		didSet {
			if resultIsPending {
				if accumulator == 0.0 {
					description = ""
				} else {
					description = "\(transitionalDescription.0) \(transitionalDescription.1) ..."
				}
			} else {
				description = "\(transitionalDescription.0) \(transitionalDescription.1) ="
			}											  
		}
	}
		
	private var accumulator: Double? {
		didSet {
			if let acc = accumulator {
				if resultIsPending {
					transitionalDescription.0 = acc
				} else {
					transitionalDescription.1 = "\(acc)"
				}
			}
		}
	}

	private enum Operation {
		case constant(Double)
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double, Double) -> Double)
		case equals
		case clear
	}

	private var operations: [String : Operation] = [
		"π" : Operation.constant(Double.pi),
		"e" : Operation.constant(M_E),
		"√" : Operation.unaryOperation(sqrt),
		"sin" : Operation.unaryOperation(sin),
		"cos" : Operation.unaryOperation(cos),
		"tan" : Operation.unaryOperation(tan),
		"pow" : Operation.binaryOperation(pow),
		"%" : Operation.unaryOperation(findPercentage),
		"±" : Operation.unaryOperation(changeSign),
		"+" : Operation.binaryOperation(add),
		"-" : Operation.binaryOperation(subtract),
		"×" : Operation.binaryOperation(multiply),
		"÷" : Operation.binaryOperation(divide),
		"=" : Operation.equals,
		"C" : Operation.clear
	]

	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			formatDescription()
			
			switch operation {
			case .constant(let value):
				accumulator = value
			case .unaryOperation(let function):
				if accumulator != nil {
					accumulator = function(accumulator!)
				}
			case .binaryOperation(let function):
				if let acc = accumulator {
					resultIsPending = true
					transitionalDescription.1 = symbol
					pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
					accumulator = nil
				}
			case .equals:
				performPendingBinaryOperation()
			case .clear:
				accumulator = 0.0
				transitionalDescription = (0.0, "", "")
				description = ""
			}
		}
	}
	
	mutating private func formatDescription() {

	}
	
	mutating private func performPendingBinaryOperation() {
		guard let pendingOperation = pendingBinaryOperation,
			let acc = accumulator else {
				return
		}
		
		resultIsPending = false
		accumulator = pendingOperation.perform(with: acc)
		pendingBinaryOperation = nil
		formatDescription()
	}

	private var pendingBinaryOperation: PendingBinaryOperation?

	private struct PendingBinaryOperation {
		let function: (Double, Double) -> Double
		let firstOperand: Double

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}

	mutating func setOperand(_ operand: Double) {
		accumulator = operand
	}

	var result: Double? {
		get {
			return accumulator
		}
	}

}
