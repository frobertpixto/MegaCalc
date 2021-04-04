//
//  MegaDecimalAlgo.swift
//  Calc1
//
//  Created by Francois Robert on 2016-12-02.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import Foundation

enum MegaDecimalAlgoError: Error {
	case cancelled
}

protocol MegaDecimalAlgoDelegate
{
	func algoStarted(withQuantitativeProgression : Bool)
	func algoProgressIndeterminate()
	func algoProgressed(progressPercent : Int)
	func algoEnded()
}

//extension MegaDecimalAlgoDelegate {
//	func algoEnded() {
//		// Optional
//	}
//}

class MegaDecimalAlgo
{
	var isCancelled = false
	var delegate:MegaDecimalAlgoDelegate? = nil
	
	func cancel()
	{
		// Note: No locking for possible race condition on isCancelled. This is OK in a Calculator context.
		isCancelled = true
	}
	
	func factorial(_ a : Int64) throws -> BigInteger
	{
		// Set-up
		prepare()
		
		delegate?.algoStarted(withQuantitativeProgression: true)

		defer {
			// Any Clean-up
			delegate?.algoEnded()
		}

		// Early exits
		if a < 1
		{
			return BigInteger(0)
		}
		
		if a < 3
		{
			return BigInteger(a)
		}
		
		let progressDivisor = a / 100
		var progress = 0
		
		var fact = BigInteger(2)
		
		// Iterate
		for number in 3...a
		{
			fact *= BigInteger(number)
			
			if isCancelled
			{
				throw MegaDecimalAlgoError.cancelled
			}
			
			if progressDivisor > 0 && number % progressDivisor == 0
			{  // Show progression
				progress += 1
				delegate?.algoProgressed(progressPercent: progress)
//				delegate?.algoProgressIndeterminate()
			}
		}

		return fact
	}
	
	func factorialFast(_ a : Int64) throws -> BigInteger
	{
		// Set-up
		prepare()
		
		delegate?.algoStarted(withQuantitativeProgression: true)
		
		defer {
			// Any Clean-up
			delegate?.algoEnded()
		}
		
		// Early exits
		if a < 1
		{
			return BigInteger(0)
		}
		
		if a < 3
		{
			return BigInteger(a)
		}
		
		let progressDivisor = a / 100
		var progress = 0
		
		var fact = BigInteger(2)
		
		var multAccumulator : Int64 = 1
		//var multAndOneMore = 0
		
		let maxAccumulatorValue : Int64 = INT64_MAX / 100_000
		
		// Iterate
		outerFor: for number in 3...a
		{
			while multAccumulator < maxAccumulatorValue && number < a
			{
				multAccumulator *= number
				continue outerFor
			}
			
			fact *= BigInteger(multAccumulator)
//			fact *= BigInteger(number)
			
			if number == a
			{
				fact *= BigInteger(a)
			}

			multAccumulator = number
			
			if isCancelled
			{
				throw MegaDecimalAlgoError.cancelled
			}
			
			if progressDivisor > 0 && number % progressDivisor == 0
			{  // Show progression
				progress += 1
				delegate?.algoProgressed(progressPercent: progress)
				//				delegate?.algoProgressIndeterminate()
			}
		}
		
		return fact
	}
	
	func isPrime(_ a : BigInteger) throws -> Bool
	{
		// TODO: Improve Algo. See: https://en.wikipedia.org/wiki/Primality_test
		
		// Set-up
		prepare()
		
		delegate?.algoStarted(withQuantitativeProgression: false)
		
		defer {
			// Any Clean-up
			delegate?.algoEnded()
		}
		
		guard a.isPositive else {
			return false
		}

		var factor 		= BigInteger(2)
		var maxCheck 	= BigInteger()
		let digitCount = a.digitCount()
		
		if (digitCount < 19)
		{
			if let aNum = Double(a.toString())
			{
				maxCheck = BigInteger(Int64(floor(sqrt(aNum))))
			}
			else{
				assert(false, "Double(a.toString()) failed")
			}
		}
		else
		{
			maxCheck = try getUpperSquareRootApproximation(a: a)
		}
		
		// Do a quick check for some obvious cases where the number will never be prime
		if digitCount > 1
		{
			let lsd = a.leastSignificantDigit()
			if lsd == 0 || lsd == 2 || lsd == 4 || lsd == 5 || lsd == 6 || lsd == 8
			{
				// Number >= 10 ending with [0,2,4,5,6,8] cannot be prime
				return false
			}
		}
		
		// Prepare the UI for Progression
		delegate?.algoProgressIndeterminate()
		
		let zero = BigInteger(0)
		let one	= BigInteger(1)
		
		while factor <= maxCheck
		{
			if try a % factor == zero
			{
				return false
			}
			
			factor += one
			
			if isCancelled
			{
				throw MegaDecimalAlgoError.cancelled
			}
		}
		
		return true
	}
	
	func smallerOrEqualPrime(_ a : BigInteger) throws -> BigInteger
	{
		// Set-up
		prepare()
		
		delegate?.algoStarted(withQuantitativeProgression: false)
		
		defer {
			// Any Clean-up
			delegate?.algoEnded()
		}
		
		var currentValue = a
		
		let zero = BigInteger(0)
		let one	= BigInteger(1)
		let two	= BigInteger(2)
		
		while currentValue.isPositive
		{
			var factor		= two
			var maxCheck	= BigInteger()
			
			if (a.digitCount() < 19)
			{
				if let aNum = Double(a.toString())
				{
					maxCheck = BigInteger(Int64(floor(sqrt(aNum))))
				}
				else{
					assert(false, "Double(a.toString()) failed")
				}
			}
			else
			{
				maxCheck = try getUpperSquareRootApproximation(a: a)
			}
			
			while factor <= maxCheck
			{
				if try currentValue % factor == zero
				{
					delegate?.algoProgressIndeterminate()
					currentValue -= one
					factor		= two
					continue
				}
				
				factor += one
				
				if isCancelled
				{
					throw MegaDecimalAlgoError.cancelled
				}
			}
			
			if factor > maxCheck
			{
				// this is a Prime
				break
			}
		}
		
		return currentValue
	}
	
	///
	/// We want an approximation of the root number, something like BigInteger(Int64(floor(sqrt(a))))
	/// Required to set a upper limit for Prime number evaluation as the max factor of a is the square root of a.
	///
	/// - parameter a:  The Operand
	/// - returns:  a good fast approximation
	private func getUpperSquareRootApproximation(a: BigInteger) throws -> BigInteger
	{
//		let upperSquareRootApproximation = try a / BigInteger(2)
		
		// Find a Exp10 value that is fast.
		// Use the following approximation. Fast to compute and smaller than a division by 2.
		// 0..10						: 10
		// 11..100					: 10
		// 101..1_000				: 100
		// 1_001..10_000			: 100
		// 10_001..100_000		: 1000
		// 100_001..1_000_000	: 1000
		// and so on...
		let nbDigits = a.digitCount()
		let exponent = ((nbDigits - 1) / 2) + 1
		let upperSquareRootApproximation = BigInteger(1).exp10(exponent)
		
		return upperSquareRootApproximation
		
		// TODO Calculate a better approximation using a table of the squares between 1 and 10 that we are going to apply to the the first 2 non-zero digits. Lets call this sqrt100 (upper square based on table)
		// Ex: sqrt100(33) = 6, sqrt100(36) = 6, sqrt100(37) = 7
		// 0..100					: 1*sqrt100.      Ex: 55     -> 8   > Actual Max: 7
		// 101..10_000  			: 10*sqrt100      Ex: 5512   -> 80  > Actual Max: 74
		// 10_001..1_000_000	   : 100*sqrt100     Ex: 551234 -> 800 > Actual Max: 742
		// and so on...

		
	}
	
	private func prepare()
	{
		isCancelled = false
	}
}
