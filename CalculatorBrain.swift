//
//  CalculatorBrain.swift
//  CS193PAssignment1
//
//  Created by Artem Alekseev on 07/02/2018.
//  Copyright © 2018 Artem Alekseev. All rights reserved.
//

import UIKit

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
	private var accumulator: Double?

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
			switch operation {
			case .constant(let value):
				accumulator = value
			case .unaryOperation(let function):
				if accumulator != nil {
					accumulator = function(accumulator!)
				}
			case .binaryOperation(let function):
				if let acc = accumulator {
					pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
					accumulator = nil
				}
				break
			case .equals:
				performPendingBinaryOperation()
			case .clear:
				accumulator = 0.0
			}
		}
	}
	
	mutating private func performPendingBinaryOperation() {
		guard let pendingOperation = pendingBinaryOperation,
			let acc = accumulator else {
				return
		}
		accumulator = pendingOperation.perform(with: acc)
		pendingBinaryOperation = nil
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
