//
//  BigInteger.swift
//  Calc1
//
//  Created by Francois Robert on 2016-11-23.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import Foundation

extension String {

	 var length: Int {
		  return count
	 }

	 subscript (i: Int) -> String {
		  return self[i ..< i + 1]
	 }

	 func substring(fromIndex: Int) -> String {
		  return self[min(fromIndex, length) ..< length]
	 }

	 func substring(toIndex: Int) -> String {
		  return self[0 ..< max(0, toIndex)]
	 }

	 subscript (r: Range<Int>) -> String {
		  let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
														  upper: min(length, max(0, r.upperBound))))
		  let start = index(startIndex, offsetBy: range.lowerBound)
		  let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		  return String(self[start ..< end])
	 }
}

enum BigIntegerError: Error {
	case invalidNumber(description: String)
	case divideByZero
	case tooBigForInt64
}

public class BigInteger : CustomStringConvertible, Comparable, Equatable, Hashable //, Integer//, SignedNumber
{
	private var mPositiveSign	= true
	private let mOctobleList	= IntegerList() // The full number is represented as a list of 8 digits integers. We call a 8 digits integer value an Octoble
	private var mNbOctobles		= 0;
	
	private static let intMinForBigInteger = BigInteger(Int64.min + 1)
	private static let intMaxForBigInteger = BigInteger(Int64.max - 1)
	
	var isPositive: Bool {
		get {
			return mPositiveSign
		}
		set {
			mPositiveSign = newValue
		}
	}
	
	public var description: String {
		return toString()
	}
	
	public func hash(into hasher: inout Hasher) {
		 hasher.combine(getHashCode())
	}

	// MARK: - CTOR
	init()
	{
		// Default to 0
		mNbOctobles = 1
		_ = mOctobleList.add(0)
		
	}
	
	init(_ a: BigInteger, hasReversedSign: Bool = false)
	{
		isPositive = a.isPositive
		
		if hasReversedSign {
			isPositive = !isPositive
		}
		
		mNbOctobles = a.mNbOctobles
		
		for index in 0..<mNbOctobles
		{
			_ = mOctobleList.add(a.mOctobleList[index])
		}
	}
	
	init(_ a: Int64, hasReversedSign: Bool = false)
	{
		if (a > 0 && hasReversedSign) || (a < 0 && hasReversedSign == false)
		{
			isPositive = false
		}
		
		let digitString = String(a < 0 ? -a : a)
		
		// Prepare the list of Octobles, Starting from the End. So 123456789 will be stored as [0] = 23456789, [1] = 1
		let digitStringLength = digitString.count
		mNbOctobles		= ((digitStringLength - 1) / 8) + 1
		var octobleNo	= 0;
		
		while (octobleNo < mNbOctobles)
		{
			let endString		= digitStringLength - 1 - (octobleNo * 8);
			var beginString	= digitStringLength - 8 - (octobleNo * 8);
			
			if octobleNo + 1 == mNbOctobles
			{
				beginString = 0;
			}
			
			let octobleValue = getOctobleValue(fromString: digitString, endPosition:endString, startPosition:beginString);
			_ = mOctobleList.add(octobleValue);
			octobleNo += 1
		}
	}
	
	required public convenience init(integerLiteral val: Int64) {
		self.init(val)
	}
	
	init?(_ a: String, hasReversedSign: Bool = false)
	{
		guard validateStringNumber(a) else {
			return nil
		}
		
		let firstChar			= a[0];
		var startDigitIndex	= 0;
		
		if firstChar == "-" || firstChar == "+"
		{
			startDigitIndex	= 1;
			isPositive			= firstChar == "+"
		}
		
		if hasReversedSign
		{
			isPositive = !isPositive
		}
		
		let realLength		= a.count - startDigitIndex
		guard realLength > 0 else {
			return nil
		}

		// Prepare the list of Octobles, Starting from the End. So 123456789 will be stored as [0] = 23456789, [1] = 1
		let digitString	= a[Range(startDigitIndex...realLength)]
		let nbOctobles		= ((realLength - 1) / 8) + 1
		var octobleNo		= 0
		
		while octobleNo < nbOctobles
		{
			let endStringPos		= realLength - 1 - (octobleNo * 8)
			var beginStringPos	= realLength - 8 - (octobleNo * 8)
			
			if octobleNo + 1 == nbOctobles
			{
				beginStringPos = 0
			}
			
			let octobleValue = getOctobleValue(fromString: digitString, endPosition: endStringPos, startPosition: beginStringPos)
			_ = mOctobleList.add(octobleValue)
			octobleNo += 1
		}
		
		mNbOctobles = nbOctobles
		
		if isNumberZero()
		{
			isPositive = true
		}

		removeLeftZeroes()
	}
	
	private init?(pByteList : [UInt8], pStart : Int, pLength: Int)
	{
		let endIndex = pStart + pLength - 1;
		assert(pStart >= 0)
		assert(endIndex < pByteList.count)
		assert(pLength > 0)
		
		guard pStart >= 0 && endIndex < pByteList.count && pLength > 0 else {
			return nil
		}
		
		// Prepare the list of Octobles, starting from the end
		let nbOctobles = ((pLength - 1) / 8) + 1
		var octobleNo = 0
		
		while (octobleNo < nbOctobles)
		{
			let endPos = endIndex - (octobleNo * 8)
			var beginPos = endIndex - 7 - (octobleNo * 8)
			
			if (octobleNo + 1 == nbOctobles)
			{
				beginPos = pStart
			}
			
			assert(beginPos <= endPos)
			
			var octobleValue = 0
			for i in beginPos...endPos
			{
				octobleValue = (octobleValue * 10) + Int(pByteList[i])
			}
			
			_ = mOctobleList.add(octobleValue)
			octobleNo += 1
		}
		
		mNbOctobles = nbOctobles;
		
		removeLeftZeroes();
	}
	
	// MARK: - public static
	public static func + (a: BigInteger, b: BigInteger) -> BigInteger
	{
		if a.isPositive == false && b.isPositive == false
		{  // -2 + -5 -==> -(+2 + +5)
			return -(-a + -b)
		}
		if a.isPositive == true && b.isPositive == false
		{  // +2 + -5 -==> +2 - +5
			return a - -b
		}
		if a.isPositive == false && b.isPositive == true
		{  // -2 + +5 -==> +5 - +2
			return b - -a
		}
		
		let result = BigInteger()
		
		var carry = 0;
		let maxOctobles = max(a.mNbOctobles, b.mNbOctobles)
		
		for index in 0..<maxOctobles
		{
			let valA	= (index >= a.mNbOctobles) ? 0 : a.mOctobleList[index];
			let valB = (index >= b.mNbOctobles) ? 0 : b.mOctobleList[index];
			let res	= valA + valB + carry;
			carry		= res / 100_000_000;
			
			if index < result.mNbOctobles
			{
				result.mOctobleList[index] = res % 100_000_000
			}
			else
			{
				_ = result.mOctobleList.add(res % 100_000_000)
			}
		}
		
		if carry > 0
		{
			_ =  result.mOctobleList.add(carry);
		}
		
		result.mNbOctobles = result.mOctobleList.count
		
		result.removeLeftZeroes();
		
		return result
	}
	
	public static func += (left: inout BigInteger, right: BigInteger)
	{
		left = left + right
	}
	
	public static func - (a: BigInteger, b: BigInteger) -> BigInteger
	{
		if a.isPositive == false && b.isPositive == false
		{  // -2 - -5 -==> +5 - +2
			return -b - -a
		}
		if a.isPositive == true && b.isPositive == false
		{  // +2 - -5 -==> +2 + +5
			return a + -b
		}
		if a.isPositive == false && b.isPositive == true
		{  // -2 - +5 -==> -(+5 + +2)
			return -(b + -a)
		}
		if a.isPositive == true && b.isPositive == true && b > a
		{  // +2 - +5 -==> -(+5 - +2)
			return -(b - a)
		}
		
		let result = BigInteger(a)
		
		// Perform A - B, where A >= B and A > 0 and B > 0
		var carry = 0
		let maxOctobles = a.mNbOctobles;
		
		for index in 0..<maxOctobles
		{
			let valA	= (index >= a.mNbOctobles) ? 0 : a.mOctobleList[index];
			let valB = (index >= b.mNbOctobles) ? 0 : b.mOctobleList[index];
			let res	= valA - valB + carry
			carry		= res < 0 ? -1 : 0 //      ((100_000_000 + res) / 100_000_000) - 1
			
			// length(a) >= length(b), so we know that all octobles are already allocated
			result.mOctobleList[index] = (100_000_000 + res) % 100_000_000
		}
		
		result.removeLeftZeroes();
		
		return result
	}

	public static func -= (left: inout BigInteger, right: BigInteger)
	{
		left = left - right
	}

	public static prefix func - (a: BigInteger) -> BigInteger
	{
		return a.isNumberZero() ? BigInteger(0) : BigInteger(a, hasReversedSign:true)
	}
	
	public static func * (a: BigInteger, b: BigInteger) -> BigInteger
	{
		let result = BigInteger()
		result.isPositive = (a.isPositive && b.isPositive) || (!a.isPositive && !b.isPositive)
		
		let maxA		= a.mNbOctobles;
		let maxB		= b.mNbOctobles;
		var carry: Int64 = 0, carry2: Int64 = 0
		var depIA	= maxA - 1
		var depIB	= maxB - 1
		let maxRes	= maxA + maxB - 1
		var iRes		= 0
		
		while iRes <= maxRes
		{
			var iA = depIA;
			var iB = depIB;
			
			var somme : Int64 = carry
			assert(somme >= 0)
			carry		= carry2;
			carry2	= 0;
			
			while ((iA >= 0) && (iB <= maxB-1))
			{
				let lMult: Int64 = Int64(a.mOctobleList[maxA - 1 - iA]) * Int64(b.mOctobleList[maxB - 1 - iB])  // TODO: Explain the index
				somme += lMult
				
				if (somme > Int64.max - 10_000_000_000_000_000)		//First overflow
				{
					//  --> TODO: Verify which number size makes this code required. // This Overflow stuff is not required with quabbles (4 digits) with a 64 bits Int64. We should try octobles (8 digits) to make this faster on 64 bits.
					carry += somme / 100_000_000
					assert(carry < Int64.max - 100_000_000)
					somme = somme % 100_000_000
					
					if carry > Int64.max - 100_000_000				//TODO Second overflow. Why is this required?
					{
						carry2 += carry / 100_000_000
						assert(carry2 < Int64.max - 100_000_000)
						carry = carry % 100_000_000
					}
				}
				
				iA -= 1
				iB += 1
			}
			
			assert (depIB >= 0)
			
			if depIB == 0
			{
				depIA -= 1
			}
			else
			{
				depIB -= 1
			}
			
			let iValue = Int(somme % 100_000_000)
			assert(iValue >= 0)
			carry += somme / 100_000_000
			
			if iRes < result.mNbOctobles
			{
				result.mOctobleList[iRes] = iValue
			}
			else
			{
				_ = result.mOctobleList.add(iValue)
			}
			
			iRes += 1
		}
		
		result.mNbOctobles = result.mOctobleList.count;
		result.removeLeftZeroes()
		
		return result
	}
	
	public static func *= (left: inout BigInteger, right: BigInteger)
	{
		left = left * right
	}

	public static func / (a: BigInteger, b: BigInteger) throws -> BigInteger
	{
		let positiveB	= abs(b)
		
		if abs(a) < positiveB
		{
			return BigInteger(0) // result is smaller than 1, return 0
		}
		
		if b.isNumberZero()
		{
			throw BigIntegerError.divideByZero
		}
		
		let lengthA = a.digitCount()
		let lengthB = b.digitCount()
		
		// For small numbers, let's take a shortcut!
		if lengthA < 19 && lengthB < 19
		{
			let strA = a.toString()
			let strB = b.toString()
			
			if let valA = Int64(strA), let valB = Int64(strB), valB != 0
			{
				return BigInteger(valA / valB)
			}
		}
		
		// Perform Division
		let arrayA		= a.toByteArray()
		var evalValue	= BigInteger(pByteList: arrayA, pStart: 0, pLength: lengthB)!
		var quotient	= BigInteger(0)
		
		for iA in 0...(lengthA - lengthB)
		{
			quotient = quotient.exp10(1)  // Same as Quotien *= 10; but faster
			
			while evalValue >= positiveB
			{
				evalValue -= positiveB
				quotient  += BigInteger(1)
			}
			
			if iA + lengthB < lengthA
			{
				evalValue = evalValue.exp10(1) + BigInteger(Int64(arrayA[iA + lengthB]))
			}
		}
		
		quotient.isPositive	= (a.isPositive && b.isPositive) || (!a.isPositive && !b.isPositive)
		quotient.mNbOctobles = quotient.mOctobleList.count;
		quotient.removeLeftZeroes()
		
		return quotient;
	}

	public static func /= (left: inout BigInteger, right: BigInteger) throws
	{
		left = try left / right
	}
	
	public static func % (a: BigInteger, b: BigInteger) throws -> BigInteger
	{
		if b.isNumberZero()
		{
			throw BigIntegerError.divideByZero
		}
		
		let lengthA = a.digitCount()
		let lengthB = b.digitCount()
		
		// For small numbers, let's take a shortcut!
		if lengthA < 19 && lengthB < 19
		{
			let strA = a.toString()
			let strB = b.toString()
			
			if let valA = Int64(strA), let valB = Int64(strB), valB != 0
			{
				return BigInteger(valA % valB)
			}
		}
		
		let positiveB	= abs(b)
		
		if abs(a) < positiveB
		{
			return BigInteger(a) // quotient will be zero, modulo is a
		}
		
		// Perform Division. The remainder will be in evalValue
		let arrayA		= a.toByteArray()
		var evalValue	= BigInteger(pByteList: arrayA, pStart: 0, pLength: lengthB)!
		var quotient	= BigInteger(0)
		
		for iA in 0...(lengthA - lengthB)
		{
			quotient = quotient.exp10(1)  // Same as Quotien *= 10; but faster
			
			while evalValue >= positiveB
			{
				evalValue -= positiveB
				quotient  += BigInteger(1)
			}
			
			if iA + lengthB < lengthA
			{
				evalValue = evalValue.exp10(1) + BigInteger(Int64(arrayA[iA + lengthB]))
			}
		}
		
		evalValue.isPositive		= a.isPositive
		evalValue.mNbOctobles	= evalValue.mOctobleList.count;
		evalValue.removeLeftZeroes()
		
		return evalValue;
	}
	
	public static func > (a: BigInteger, b: BigInteger) -> Bool
	{
		if a.isPositive == true && b.isPositive == false
		{
			return true
		}
		if a.isPositive == false && b.isPositive == true
		{
			return false
		}
		if a.isPositive == false && b.isPositive == false
		{
			return -a < -b
		}
		
		// At this point, we can assume that we compare to positive number
		if a.mNbOctobles > b.mNbOctobles
		{
			return true
		}
		
		if a.mNbOctobles < b.mNbOctobles
		{
			return false
		}

		// At this point, we can assume that we compare to positive number of same size
		for index in (0...a.mNbOctobles-1).reversed()
		{
			let valA = a.mOctobleList[index]
			let valB = b.mOctobleList[index]
			
			if valA > valB
			{
				return true
			}
			
			if valA < valB
			{
				return false
			}
		}
		
		// Totally equal
		return false
	}
	
	public static func < (a: BigInteger, b: BigInteger) -> Bool
	{
		if a.isPositive == false && b.isPositive == true
		{
			return true
		}
		if a.isPositive == true && b.isPositive == false
		{
			return false
		}
		if a.isPositive == false && b.isPositive == false
		{
			return -a > -b
		}
		
		// At this point, we can assume that we compare to positive number
		if a.mNbOctobles < b.mNbOctobles
		{
			return true
		}
		
		if a.mNbOctobles > b.mNbOctobles
		{
			return false
		}
		
		// At this point, we can assume that we compare to positive number of same size
		for index in (0...a.mNbOctobles-1).reversed()
		{
			let valA = a.mOctobleList[index]
			let valB = b.mOctobleList[index]
			
			if valA < valB
			{
				return true
			}
			
			if valA > valB
			{
				return false
			}
		}
		
		// Totally equal
		return false
	}
	
	public static func == (a: BigInteger, b: BigInteger) -> Bool
	{
		if a.isPositive != b.isPositive
		{
			return false
		}
		
		// At this point, we can assume that we compare to same sign number
		if a.mNbOctobles != b.mNbOctobles
		{
			return false
		}
		
		// At this point, we can assume that we compare positive numbers of same size
		for index in 0...a.mNbOctobles-1
		{
			let valA = a.mOctobleList[index]
			let valB = b.mOctobleList[index]
			
			if valA != valB
			{
				return false
			}
		}
		
		// Totally equal
		return true
	}
	
	public static func >= (a: BigInteger, b: BigInteger) -> Bool
	{
		return (a == b) || (a > b);
	}

	public static func <= (a: BigInteger, b: BigInteger) -> Bool
	{
		return (a == b) || (a < b);
	}
	
	public static func != (a: BigInteger, b: BigInteger) -> Bool
	{
		return !(a == b);
	}
	
	
	public static func abs(_ a: BigInteger) -> BigInteger
	{
		return a >= BigInteger(0) ? BigInteger(a) : BigInteger(a, hasReversedSign: true)
	}
	
	// MARK: - public

	///
	/// Test for a Zero value
	///
	/// - returns:  True if the value is Zero.
	public func isNumberZero() -> Bool
	{
		for value in mOctobleList where value != 0
		{
			return false
		}
		
		return mNbOctobles > 0
	}
	
	///
	/// Print the value of the BigInteger.
	/// Note that the octobles are stored in reverse order.
	///
	/// - returns:  The BigInteger value as a String
	public func toString() -> String {
		
		var result : String = ""
		
		if mNbOctobles <= 0
		{
			return result
		}
		
		if isPositive == false
		{
			result += "-"
		}

		let firstVal = mOctobleList[mNbOctobles-1]
		result.append(String.init(format: "%ld", firstVal))
		
		if mNbOctobles > 1
		{
			for index in (0...mNbOctobles-2).reversed()
			{
				let valA = mOctobleList[index]
				
				result.append(String.init(format: "%ld%ld%ld%ld%ld%ld%ld%ld", valA / 10_000_000, (valA % 10_000_000) / 1_000_000, (valA % 1_000_000) / 100_000, (valA % 100_000) / 10_000, (valA % 10_000) / 1_000, (valA % 1_000) / 100, (valA % 100) / 10, valA % 10))
			}
		}
		
		return result
	}
	
	///
	/// Try to convert the BigInteger to an Int64
	///
	/// - returns:  The Int64 number if successfull or a BigIntegerError.tooBigForInt64 error if it failed.
	public func toInt() throws -> Int64
	{
		if self >= BigInteger.intMinForBigInteger && self <= BigInteger.intMaxForBigInteger
		{
			// TODO: Return actual int value + validate if cast error
			return Int64(toString())!
		}
		else
		{
			throw BigIntegerError.tooBigForInt64
		}
	}
	
	/// Gets the length. This is the number of significant digits. Sign is not considered
	///
	/// - returns:  the number of digits in the number
	public func digitCount() -> Int
	{
		var length		= (mNbOctobles - 1) * 8
		let octoble0	= mOctobleList[mNbOctobles - 1]
	
		switch octoble0
		{
			case 0...9:
				length += 1
			case 10...99:
				length += 2
			case 100...999:
				length += 3
			case 1_000...9_999:
				length += 4
			case 10_000...99_999:
				length += 5
			case 100_000...999_999:
				length += 6
			case 1_000_000...9_999_999:
				length += 7
			case 10_000_000...99_999_999:
				length += 8
			default:
				assert(false)
		}
		
		return length
	}
	
	///
	/// Obtain the least significant digit of a number. Ex: for number 2006, it will return 6
	///
	/// - returns:  The least significant digit of a number
	public func leastSignificantDigit() -> Int
	{
		if mNbOctobles == 0 || mOctobleList.count == 0
		{
			return 0
		}
		
		let lestSignificantOctoble = mOctobleList[0]
		
		return lestSignificantOctoble % 10
	}
	
	///
	/// Returns number * 10exp(8*nbExponent). This is a a specific case for which processing
	/// should be faster than the general EXP10 method
	///
	/// - parameter nbExponent:  Exponent.
	/// - returns:  The result number
	public func exp100000000(_ nbExponent : Int) -> BigInteger
	{
		var result = BigInteger(self)
		
		if nbExponent > 0
		{
			let newValues = IntegerList()
			
			// We will add "exponent" 0 value octobles
			for _ in 0..<nbExponent
			{
				_ = newValues.add(0)
			}
			
			result.mOctobleList.insertRange(atIndex: 0, arrayToInsert: newValues)
			result.mNbOctobles += nbExponent
		}
		else if nbExponent < 0 && result.mNbOctobles + nbExponent <= 0
		{
			// Number is too small.
			result = BigInteger(0)
		}
		else
		{
			// Each octoble removed represent a division by 100_000_000
			result.mOctobleList.removeRange(atIndex: 0, count: -nbExponent)
			result.mNbOctobles += nbExponent;
		}
		
		return result
	}
	
	///
	/// Returns number * 10exp(nbExponent).
	///
	/// - parameter nbExponent:  Exponent
	/// - returns:  The result number
	public func exp10(_ nbExponent : Int) -> BigInteger
	{
		var result = BigInteger(self)

		if nbExponent == 0 || result.isNumberZero()
		{
			return result
		}

		if (nbExponent % 8 == 0)
		{
			return result.exp100000000(nbExponent / 8)
		}
		
		var byteArray	= result.toByteArray()
		let length		= result.digitCount()
		
		if (nbExponent < 0)
		{
			// Shift to the left. Ex: 123.Exp(-2) ==> 1
			if (length + nbExponent) <= 0
			{  // Nothing remains. Ex: 123.Exp(-4) ==> 0
				result = BigInteger()
			}
			else
			{
				result = BigInteger(pByteList: byteArray, pStart: 0, pLength: length + nbExponent)!
			}
		}
		else
		{
			// Shift to the right. Ex: 123.exp10(2) ==> 12300
			byteArray.append(contentsOf: [UInt8](repeating: 0, count: nbExponent))
			
			if let shiftedResult = BigInteger(pByteList:byteArray, pStart: 0, pLength:length + nbExponent)
			{
				result = shiftedResult
			}
			else
			{
				assert(false)
			}
		}
		
		if result.isNumberZero() == false
		{
			result.isPositive = self.isPositive
		}
		
		return result
	}
	
	
	// MARK: - private
	
	///
	/// Gets a octoble value from a string range.
	///
	/// - parameter fromString: The digit string.
	/// - parameter endPosition: The end position.
	/// - parameter startPosition: The begin position.
	/// - returns:  the value
	private func getOctobleValue(fromString digitString: String, endPosition: Int, startPosition: Int) -> Int
	{
		assert(startPosition <= endPosition)
		assert(digitString.count > 0)
		
		let substring			= digitString[Range(startPosition...endPosition)]
		if let octobleValue	= Int(substring)
		{
			return octobleValue
		}
		else
		{
			return 0
		}
	}
	
	///
	/// Validates the string number.
	///
	/// - parameter pNumber:  The string which contains the number to validate
	/// - returns:  true if valid
	private func validateStringNumber(_ pNumber : String) -> Bool
	{
		let length = pNumber.count
		
		guard length > 0 else {
			return false
		}
		
		let characters = [Character](pNumber)
	
		var oneChar = characters[0];
		var startIndex = 0;
		
		if oneChar == "-" || oneChar == "+"
		{
			startIndex = 1;
		}
		
		for index in startIndex..<length
		{
			oneChar = characters[index]
			
			if oneChar < "0" || oneChar > "9"
			{
				return false
			}
		}
		
		// Todo Add more validations
		return true
	}
	
	///
	/// Removes the left octobles that contains only zeroes. Because they are not significative.
	///
	private func removeLeftZeroes()
	{
		for index in (0...mNbOctobles-1).reversed()
		{
			let valA = mOctobleList[index]
		
			if valA == 0 && index > 0
			{
				mOctobleList.removeAt(index)
				mNbOctobles -= 1
			}
			else
			{
				// Once we find a non-zero value, we are done!
				break
			}
		}
	}
	
	private func toByteArray() -> [UInt8]
	{
		let length			= digitCount()
		var newByteArray	= [UInt8](repeating: 0, count: length)
	
		var pos = 0
		for index in (0...mNbOctobles-1).reversed()
		{
			let octobleValue = mOctobleList[index]
		
			if (index == mNbOctobles - 1 && octobleValue < 10_000_000)
			{  // First octoble value. The first non-significant zeroes are skipped
				if (octobleValue / 1_000_000 > 0)
				{  // Case 01234567 -> 1234567
					newByteArray[pos + 0] = UInt8(octobleValue / 1_000_000)
					newByteArray[pos + 1] = UInt8((octobleValue % 1_000_000) / 100_000)
					newByteArray[pos + 2] = UInt8((octobleValue % 100_000) / 10_000)
					newByteArray[pos + 3] = UInt8((octobleValue % 10_000) / 1_000)
					newByteArray[pos + 4] = UInt8((octobleValue % 1_000) / 100)
					newByteArray[pos + 5] = UInt8((octobleValue % 100) / 10)
					newByteArray[pos + 6] = UInt8(octobleValue % 10)
					pos += 7
				}
				else if (octobleValue / 100_000 > 0)
				{  // Case 00123456 -> 123456
					newByteArray[pos + 0] = UInt8(octobleValue / 100_000)
					newByteArray[pos + 1] = UInt8((octobleValue % 100_000) / 10_000)
					newByteArray[pos + 2] = UInt8((octobleValue % 10_000) / 1_000)
					newByteArray[pos + 3] = UInt8((octobleValue % 1_000) / 100)
					newByteArray[pos + 4] = UInt8((octobleValue % 100) / 10)
					newByteArray[pos + 5] = UInt8(octobleValue % 10)
					pos += 6
				}
				else if (octobleValue / 10_000 > 0)
				{  // Case 00012345 -> 12345
					newByteArray[pos + 0] = UInt8(octobleValue / 10_000)
					newByteArray[pos + 1] = UInt8((octobleValue % 10_000) / 1_000)
					newByteArray[pos + 2] = UInt8((octobleValue % 1_000) / 100)
					newByteArray[pos + 3] = UInt8((octobleValue % 100) / 10)
					newByteArray[pos + 4] = UInt8(octobleValue % 10)
					pos += 5
				}
				else if (octobleValue / 1_000 > 0)
				{  // Case 00001234 -> 1234
					newByteArray[pos + 0] = UInt8(octobleValue / 1_000)
					newByteArray[pos + 1] = UInt8((octobleValue % 1_000) / 100)
					newByteArray[pos + 2] = UInt8((octobleValue % 100) / 10)
					newByteArray[pos + 3] = UInt8(octobleValue % 10)
					pos += 4
				}
				else if (octobleValue / 100 > 0)
				{  // Case 00000123 -> 123
					newByteArray[pos + 0] = UInt8(octobleValue / 100)
					newByteArray[pos + 1] = UInt8((octobleValue % 100) / 10)
					newByteArray[pos + 2] = UInt8(octobleValue % 10)
					pos += 3
				}
				else if (octobleValue / 10 > 0)
				{  // Case 00000012 -> 12
					newByteArray[pos + 0] = UInt8(octobleValue / 10)
					newByteArray[pos + 1] = UInt8(octobleValue % 10)
					pos += 2
				}
				else
				{  // Case 00000001 -> 1
					newByteArray[pos + 0] = UInt8(octobleValue);
					pos += 1
				}
			}
			else
			{
				// Other than first or first octoble has 8 digits (>= 10_000_000)
				newByteArray[pos + 0] = UInt8(octobleValue / 10_000_000)
				newByteArray[pos + 1] = UInt8((octobleValue % 10_000_000) / 1_000_000)
				newByteArray[pos + 2] = UInt8((octobleValue % 1_000_000) / 100_000)
				newByteArray[pos + 3] = UInt8((octobleValue % 100_000) / 10_000)
				newByteArray[pos + 4] = UInt8((octobleValue % 10_000) / 1_000)
				newByteArray[pos + 5] = UInt8((octobleValue % 1_000) / 100)
				newByteArray[pos + 6] = UInt8((octobleValue % 100) / 10)
				newByteArray[pos + 7] = UInt8(octobleValue % 10)
				pos += 8
			}
		}
		
		return newByteArray
	}
	
	///
	/// Calculate an integer hashcode.
	///
	private func getHashCode() -> Int
	{
		var hashcode = 0
		
		mNbOctobles = mOctobleList.count;
		
		for index in (0...mNbOctobles-1)
		{
			hashcode += mOctobleList[index]
			
			if hashcode > 2_000_000_000
			{
				hashcode %= 1_999_999_973; // A big Prime!!!
			}
		}
		
		return isPositive ? hashcode : -hashcode
	}
}
