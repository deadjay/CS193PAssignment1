//
//  CalculatorBrain.swift
//  CS193PAssignment1
//
//  Created by Artem Alekseev on 07/02/2018.
//  Copyright © 2018 Artem Alekseev. All rights reserved.
//

import UIKit

struct CalculatorBrain {
	
	private enum Operation {
		case constant(Double)
		case unary((Double) -> Double)
		case binary((Double, Double) -> Double)
		case equals
		case clear
	}
		
	private struct PendingBinaryOperation {
		let function: (Double, Double) -> Double
		let firstOperand: Double
		
		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	
	// MARK: - Properties
	
	var result: Double? {
		get {
			return accumulator
		}
	}
	
	// MARK: Private Properties
	
	private var accumulator: Double?
	private var pendingBinaryOperation: PendingBinaryOperation?
	private var operations: [String : Operation] = [
		"π"   : Operation.constant(Double.pi),
		"e"   : Operation.constant(M_E),
		"√"   : Operation.unary(sqrt),
		"sin" : Operation.unary(sin),
		"cos" : Operation.unary(cos),
		"tan" : Operation.unary(tan),
		"%"   : Operation.unary( {$0 * 0.01} ),
		"±"   : Operation.unary( {-$0} ),
		"pow" : Operation.binary(pow),
		"+"   : Operation.binary( {$0 + $1} ),
		"-"   : Operation.binary( {$0 - $1} ),
		"×"   : Operation.binary( {$0 * $1} ),
		"÷"   : Operation.binary( {$0 / $1} ),
		"="   : Operation.equals,
		"C"   : Operation.clear
	]

	// MARK - Functions
	
	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .constant(let value):
				accumulator = value
			case .unary(let function):
				if accumulator != nil {
					accumulator = function(accumulator!)
				}
			case .binary(let function):
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
	
	mutating func setOperand(_ operand: Double) {
		accumulator = operand
	}
	
	// MARK: - Private Functions
	
	mutating private func performPendingBinaryOperation() {
		guard let pendingOperation = pendingBinaryOperation,
			let acc = accumulator else {
				return
		}
		accumulator = pendingOperation.perform(with: acc)
		pendingBinaryOperation = nil
	}
}
