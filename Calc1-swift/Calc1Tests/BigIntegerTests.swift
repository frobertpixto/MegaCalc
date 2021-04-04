//
//  BigIntegerTests.swift
//  Calc1
//
//  Created by Francois Robert on 2016-11-23.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import XCTest
@testable import Calc1

class BigIntegerTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testToString0() {
		var target = BigInteger()
		var expected = "0"
		var actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(0)
		expected = "0"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(-0)
		expected = "0"
		actual = target.toString()

		target = BigInteger(0, hasReversedSign:false)
		expected = "0"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(0, hasReversedSign:true)
		expected = "0"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(-0, hasReversedSign:true)
		expected = "0"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)

		var targetB = BigInteger("")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("-")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("+")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("+12a")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("12a")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger(" 12")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("12 ")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("12 123")
		XCTAssertTrue(targetB == nil)

		targetB = BigInteger("12a123")
		XCTAssertTrue(targetB == nil)

		var targetC = BigInteger("0")
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)

		targetC = BigInteger("+0")
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)

		targetC = BigInteger("-0")
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)

		targetC = BigInteger("-0000000000")
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)

		targetC = BigInteger("0000000000")
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)
		
		targetC = BigInteger("-0000000000", hasReversedSign:true)
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)
		
		targetC = BigInteger("0000000000", hasReversedSign:false)
		XCTAssertTrue(targetC != nil)
		expected = "0"
		actual = targetC!.toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testToString01() {

		var target = BigInteger(123)
		var expected = "123"
		var actual = target.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger(12345)
		expected = "12345"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger(-12346)
		expected = "-12346"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		let targetB = BigInteger(target)
		expected = "-12346"
		actual = targetB.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger(12346, hasReversedSign:true)
		expected = "-12346"
		actual = target.toString()

		target = BigInteger(-12346, hasReversedSign:true)
		expected = "12346"
		actual = target.toString()

		XCTAssertEqual(expected, actual)

		target = BigInteger(-12346, hasReversedSign:false)
		expected = "-12346"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)

		let targetc = BigInteger(target, hasReversedSign:true)
		expected = "12346"
		actual = targetc.toString()
		
		XCTAssertEqual(expected, actual)
		
		var targetd = BigInteger(targetc, hasReversedSign:false)
		expected = "12346"
		actual = targetd.toString()
		
		XCTAssertEqual(expected, actual)

		targetd = BigInteger(targetc, hasReversedSign:true)
		expected = "-12346"
		actual = targetd.toString()
		
		XCTAssertEqual(expected, actual)

		targetd = BigInteger(targetd, hasReversedSign:false)
		expected = "-12346"
		actual = targetd.toString()
		
		XCTAssertEqual(expected, actual)

		targetd = BigInteger(targetd, hasReversedSign:true)
		expected = "12346"
		actual = targetd.toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testToString02() {
		
		var target = BigInteger("123")
		XCTAssertTrue(target != nil)
		var expected = "123"
		var actual = target!.toString()

		XCTAssertEqual(expected, actual)
		
		target = BigInteger("12345")
		XCTAssertTrue(target != nil)
		expected = "12345"
		actual = target!.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger("12345", hasReversedSign:true)
		XCTAssertTrue(target != nil)
		expected = "-12345"
		actual = target!.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger("12345678901234567890")
		XCTAssertTrue(target != nil)
		expected = "12345678901234567890"
		actual = target!.toString()
		
		XCTAssertEqual(expected, actual)

		target = BigInteger("100000000010000000001")
		XCTAssertTrue(target != nil)
		expected = "100000000010000000001"
		actual = target!.toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testToInt() {
		var target = BigInteger("123")
		XCTAssertTrue(target != nil)

		var expected : Int64 = 123
		var actual : Int64	= Int64.max
		
		do {
			try actual = target!.toInt()
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		XCTAssertEqual(expected, actual)
		
		
		target = BigInteger("-123")
		XCTAssertTrue(target != nil)
		
		expected	= -123
		actual	= Int64.max
		
		do {
			try actual = target!.toInt()
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		XCTAssertEqual(expected, actual)
		
		
		target = BigInteger()
		XCTAssertTrue(target != nil)
		
		expected	= 0
		actual	= Int64.max
		
		do {
			try actual = target!.toInt()
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger("123456789012345678")
		XCTAssertTrue(target != nil)

		expected	= 123456789012345678
		actual	= Int64.max

		do {
			try actual = target!.toInt()
		}
		catch _ {
			XCTAssertTrue(false)
		}
		XCTAssertEqual(expected, actual)

		
		target = BigInteger("12345678901234567890123")
		XCTAssertTrue(target != nil)
		
		do {
			try actual = target!.toInt()
			XCTAssertTrue(false, "Should not be convertible to Int")
		}
		catch _ {
			XCTAssertTrue(true)
		}
		
		
		target = BigInteger("-12345678901234567890123")
		XCTAssertTrue(target != nil)
		
		do {
			try actual = target!.toInt()
			XCTAssertTrue(false, "Should not be convertible to Int")
		}
		catch _ {
			XCTAssertTrue(true)
		}
	}
	
	func testIsZero() {

		var target = BigInteger()
		XCTAssertEqual(target.isNumberZero(), true)

		target = BigInteger(0)
		XCTAssertEqual(target.isNumberZero(), true)

		target = BigInteger(0)
		XCTAssertEqual(target.isNumberZero(), true)

		target = BigInteger(123)
		XCTAssertEqual(target.isNumberZero(), false)

		target = BigInteger(-12346)
		XCTAssertEqual(target.isNumberZero(), false)
	}
	
	func testNegate() {
		
		var target = BigInteger(0)
		target = -target
		var expected = "0"
		var actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(123)
		target = -target
		expected = "-123"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
		
		target = BigInteger(-12346)
		target = -target
		expected = "12346"
		actual = target.toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testAdd01() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		var expected = "234567"
		var actual = (a + b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		b = BigInteger(0)
		
		expected = "123456"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("123456")!
		b = BigInteger("0")!
		
		expected = "123456"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger("900000000001")!
		b = BigInteger("111111111111")!
		
		expected = "1011111111112"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("12345999999999999999999999999995999999999999999999999999999999")!
		b = BigInteger(1)
		
		expected = "12345999999999999999999999999996000000000000000000000000000000"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
}
	
	func testAdd02() {
		var a = BigInteger(123456)
		a += BigInteger(111111)
		
		var expected = "234567"
		var actual = a.toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		a += BigInteger(0)
		
		expected = "123456"
		actual = a.toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(-123456)
		a += BigInteger(0)
		
		expected = "-123456"
		actual = a.toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		a += BigInteger(1111111111)
		
		expected = "1111234567"
		actual = a.toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(-1)
		a += BigInteger(1)
		
		expected = "0"
		actual = a.toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(1)
		a += BigInteger(-1)
		
		expected = "0"
		actual = a.toString()
		XCTAssertEqual(expected, actual)
	}
	
	func testAdd03() {
		var a = BigInteger(123456)
		var b = BigInteger(-111111)
		
		var expected = "12345"
		var actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456)
		b = BigInteger(-111111)
		
		expected = "-234567"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456)
		b = BigInteger(+111111)
		
		expected = "-12345"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger("9999999")!
		b = BigInteger("-11111111")!
		
		expected = "-1111112"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("10000000000000000000000000000000000000000000000000000001")!
		b = BigInteger("122")!
		
		expected = "10000000000000000000000000000000000000000000000000000123"
		actual = (a + b).toString()
		XCTAssertEqual(expected, actual)
	}
	
	func testSubstract01() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		var expected = "12345"
		var actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(12)
		b = BigInteger(12)
		
		expected = "0"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-12)
		b = BigInteger(123)
		
		expected = "-135"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(0)
		b = BigInteger(123)
		
		expected = "-123"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-2)
		b = BigInteger(-5)
		
		expected = "3"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)
		a = BigInteger(-2)
		b = BigInteger(5)
		
		expected = "-7"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)
		a = BigInteger(-2)
		b = BigInteger(-5)
		
		expected = "3"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(2)
		b = BigInteger(-5)
		
		expected = "7"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(2)
		b = BigInteger(5)
		
		expected = "-3"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(2)
		b = BigInteger(55555)
		
		expected = "-55553"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("-12345600000000000000000000000000000000000000000000000002")!
		b = BigInteger("-1111100000000000000000000000000000000000000000000000003")!
		
		expected = "-11234499999999999999999999999999999999999999999999999999"
		actual = (a - b).toString()
		XCTAssertEqual(expected, actual)
}
	
	func testMultiply01() {
		var a = BigInteger(0)
		var b = BigInteger(0)
		
		var expected = "0"
		var actual = (a * b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(12)
		b = BigInteger(12)
		
		expected = "144"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-11111)
		b = BigInteger(11111)
		
		expected = "-123454321"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("-785412354123")!
		b = BigInteger("-123456789123456785101")!
		
		expected = "96964487377920975265633722321423"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("10010000000000000000000000000001001")!
		b = BigInteger("999999999999999999999999999999999999999999999999999999999")!
		
		expected = "10010000000000000000000000000001000999999999999999999999989989999999999999999999999999998999"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("0069157773088223225864010172804473666134839612717689")!
		b = BigInteger("0069157773088223225864010172804473666134839612717689")!
		
		expected = "4782797578522172663045226382857279875811551873069814817049653711727111813236706913604357108413500721"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger("0069157773088223225864010172804473666134839612717689")!
		b = BigInteger("0")!
		
		expected = "0"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger("9999999999999999999999999999999999999")!
		b = BigInteger("9999999999999999999999999999999999999")!
		
		expected = "99999999999999999999999999999999999980000000000000000000000000000000000001"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		
		a = BigInteger("9999999999999999999999999999999999999")!
		b = BigInteger("1111111111111111111111111111111111111")!
		
		expected = "11111111111111111111111111111111111108888888888888888888888888888888888889"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		
		a = BigInteger("1111111111111111111111111111111111111111111111111111111111")!
		b = BigInteger("1111111111111111111111111111111111111111111111111111111111")!
		
		expected = "1234567901234567901234567901234567901234567901234567901234320987654320987654320987654320987654320987654320987654321"
		actual = (a * b).toString()
		XCTAssertEqual(expected, actual)

		
		a = BigInteger("1")!
		b = BigInteger("2")!
		
		expected = "120"
		actual = (a * b * BigInteger(3) * BigInteger(4) * BigInteger(5)).toString()
		XCTAssertEqual(expected, actual)
	}
	
	func testDivide01() {
		var a = BigInteger(0)
		var b = BigInteger(0)
		
		var expected = "0"
		
		do {
			let _ = try (a / b).toString()
			XCTAssertTrue(false, "Divide by Zero did not occur")
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(true)
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		a = BigInteger(66)
		b = BigInteger(2)
		
		expected = "33"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
	}
	
	func testDivide02() {
		var a = BigInteger("99999999999999999999999999")!
		var b = BigInteger(3)
		
		var expected = "33333333333333333333333333"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		a = BigInteger("99999999999999999999999999")!
		b = BigInteger("-9")!
		
		expected = "-11111111111111111111111111"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
		
		a = BigInteger("60000000000000000000")!
		b = BigInteger("50")!
		
		expected = "1200000000000000000"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("-600000000000000000000")!
		b = BigInteger("50")!
		
		expected = "-12000000000000000000"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("6000000000000000000000001")!
		b = BigInteger("-500000")!
		
		expected = "-12000000000000000000"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("66666666666666666666666666666666666666666666666666666666666660001")!
		b = BigInteger("6666666666666666666666666666666666666666666666666666666666666")!
		
		expected = "10000"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("-987654321123456789987654")!
		b = BigInteger("-65432189")!
		
		expected = "15094318808796948"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("11111111111111111111111111111111111108888888888888888888888888888888888889")!
		b = BigInteger("9999999999999999999999999999999999999")!
		
		expected = "1111111111111111111111111111111111111"
		
		do {
			let actual = try (a / b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
	}

	func testModulo01() {
		var a = BigInteger(5)
		var b = BigInteger(0)
		
		var expected = "0"
		
		do {
			let _ = try (a % b).toString()
			XCTAssertTrue(false, "Divide by Zero did not occur")
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(true)
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		a = BigInteger(-67)
		b = BigInteger(2)
		
		expected = "-1"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger(30)
		b = BigInteger(50)
		
		expected = "30"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
		
		a = BigInteger(0)
		b = BigInteger(50)
		
		expected = "0"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
	}
	
	func testModulo02() {
		var a = BigInteger("128000000000000000000000000000000000000000000000345")!
		var b = BigInteger("-50000000000000000000000000000000000000000000")!
		
		var expected = "345"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch _ {
			XCTAssertTrue(false)
		}
		
		a = BigInteger("-128000000000000000000000000000000000000000345")!
		b = BigInteger("100")!
		
		expected = "-45"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

		a = BigInteger("128000000000000000000000000000000000000000345")!
		b = BigInteger("100000000000000000000000000000000000000")!
		
		expected = "345"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}
		
		a = BigInteger("128000000000000000000000000000000000000000345")!
		b = BigInteger("128000000000000000000000000000000000000000000")!
		
		expected = "345"
		
		do {
			let actual = try (a % b).toString()
			XCTAssertEqual(expected, actual)
		}
		catch BigIntegerError.divideByZero {
			XCTAssertTrue(false, "Divide by Zero")
		}
		catch let error {
			XCTAssertTrue(false, "\(error)")
		}

}
	
	func testGreaterThan() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		XCTAssertTrue(a > b)

		a = BigInteger(+123456)
		b = BigInteger(-511111)
		
		XCTAssertTrue(a > b)

		a = BigInteger(+123456)
		b = BigInteger(0)
		
		XCTAssertTrue(a > b)

		a = BigInteger(-523456)
		b = BigInteger(+111111)

		XCTAssertFalse(a > b)

		a = BigInteger(-123456)
		b = BigInteger(0)
		
		XCTAssertFalse(a > b)

		a = BigInteger(-123456)
		b = BigInteger(-111111)
		
		XCTAssertFalse(a > b)
		
		a = BigInteger(-111111)
		b = BigInteger(-123456)
		
		XCTAssertTrue(a > b)

		a = BigInteger(-111111)
		b = BigInteger(-111111)
		
		XCTAssertFalse(a > b)

		a = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000005")!
		b = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000006")!
		
		XCTAssertFalse(a > b)

		a = BigInteger("12345674000000000000000000000000000000000000000000005")!
		b = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000006")!
		
		XCTAssertFalse(a > b)
	}
	
	func testSmallerThan() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		XCTAssertFalse(a < b)
		
		a = BigInteger(+123456)
		b = BigInteger(-511111)
		
		XCTAssertFalse(a < b)
		
		a = BigInteger(+123456)
		b = BigInteger(0)
		
		XCTAssertFalse(a < b)
		
		a = BigInteger(-523456)
		b = BigInteger(+111111)
		
		XCTAssertTrue(a < b)
		
		a = BigInteger(-123456)
		b = BigInteger(0)
		
		XCTAssertTrue(a < b)
		
		a = BigInteger(-123456)
		b = BigInteger(-111111)
		
		XCTAssertTrue(a < b)
		
		a = BigInteger(-111111)
		b = BigInteger(-123456)
		
		XCTAssertFalse(a < b)
		
		a = BigInteger(-111111)
		b = BigInteger(-111111)
		
		XCTAssertFalse(a < b)
	}
	
	func testEqual() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		XCTAssertFalse(a == b)
		
		a = BigInteger(+511111)
		b = BigInteger(-511111)
		
		XCTAssertFalse(a == b)
		
		a = BigInteger(+123456)
		b = BigInteger(0)
		
		XCTAssertFalse(a == b)
		
		a = BigInteger(111111)
		b = BigInteger(+111111)
		
		XCTAssertTrue(a == b)
		
		a = BigInteger(0)
		b = BigInteger(0)

		XCTAssertTrue(a == b)
	}
	
	func testGreaterEqual() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)
		
		XCTAssertTrue(a >= b)
		
		a = BigInteger(+511111)
		b = BigInteger(-511111)
		
		XCTAssertTrue(a >= b)
		
		a = BigInteger(+123456)
		b = BigInteger(0)
		
		XCTAssertTrue(a >= b)
		
		a = BigInteger(111111)
		b = BigInteger(+111111)
		
		XCTAssertTrue(a >= b)
		
		a = BigInteger(0)
		b = BigInteger(0)

		XCTAssertTrue(a >= b)

		a = BigInteger(-13)
		b = BigInteger(-11)
		
		XCTAssertFalse(a >= b)
	}
	
	func testSmallerEqual() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)
		
		XCTAssertTrue(a <= b)
		
		a = BigInteger(-511111)
		b = BigInteger(511111)
		
		XCTAssertTrue(a <= b)
		
		a = BigInteger(0)
		b = BigInteger(1234567890)
		
		XCTAssertTrue(a <= b)
		
		a = BigInteger(111111)
		b = BigInteger(+111111)
		
		XCTAssertTrue(a <= b)
		
		a = BigInteger(0)
		b = BigInteger(0)
		
		XCTAssertTrue(a <= b)
		
		a = BigInteger(13)
		b = BigInteger(11)
		
		XCTAssertFalse(a <= b)
	}
	
	func testDifferent() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)
		
		XCTAssertTrue(a != b)
		
		a = BigInteger(-511111)
		b = BigInteger(511111)
		
		XCTAssertTrue(a != b)
		
		a = BigInteger(0)
		b = BigInteger(1234567890)
		
		XCTAssertTrue(a != b)
		
		a = BigInteger(111111)
		b = BigInteger(+111111)
		
		XCTAssertFalse(a != b)
		
		a = BigInteger(0)
		b = BigInteger(0)
		
		XCTAssertFalse(a != b)
		
		a = BigInteger(13)
		b = BigInteger(11)
		
		XCTAssertTrue(a != b)
	}
	
	func testMin() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)
		
		var expected	= "123456"
		var actual		= min(a, b).toString()
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		b = BigInteger(0)
		
		expected	= "0"
		actual		= min(a, b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456)
		b = BigInteger(0)
		
		expected	= "-123456"
		actual		= min(a, b).toString()
		XCTAssertEqual(expected, actual)
	}
	
	func testMax() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)
		
		var expected	= "1111111"
		var actual		= max(a, b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456)
		b = BigInteger(0)
		
		expected	= "0"
		actual		= max(a, b).toString()
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456)
		b = BigInteger(-12)
		
		expected	= "-12"
		actual		= max(a, b).toString()
		XCTAssertEqual(expected, actual)
	}
	
	func testAbs() {
		var a = BigInteger(123456)

		var expected	= "123456"
		var actual		= BigInteger.abs(a).toString()

		XCTAssertEqual(expected, actual)

		a = BigInteger(-123456)
		
		expected		= "123456"
		actual		= BigInteger.abs(a).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(0)
		
		expected		= "0"
		actual		= BigInteger.abs(a).toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testHashable() {
		
		var dict = [BigInteger: String]()
		
		let a = BigInteger(123456)
		let b = BigInteger(1111111)
		
		dict[a] = a.toString()
		dict[b] = b.toString()
		
		var expected	= a.toString()
		var actual		= dict[a]
		
		XCTAssertEqual(expected, actual)

		expected			= b.toString()
		actual			= dict[b]
		
		XCTAssertEqual(expected, actual)
	}
	
	func testOther() {
//		let a : BigInteger = 12
		
		let _ = BigInteger(integerLiteral: 5)
	}
	
	func testDigitCount() {
		var a = BigInteger(123456)
		
		var expected	= 6
		var actual		= a.digitCount()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456789)
		
		expected		= 9
		actual		= a.digitCount()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(0)
		
		expected		= 1
		actual		= a.digitCount()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(100)
		
		expected		= 3
		actual		= a.digitCount()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testExp100000000() {
		var a = BigInteger(123456)
		
		var expected	= "12345600000000"
		var actual		= a.exp100000000(1).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(1234567890)
		
		expected	= "12"
		actual	= a.exp100000000(-1).toString()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(123456789)
		
		expected	= "0"
		actual	= a.exp100000000(-2).toString()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(1234)
		
		expected	= "0"
		actual	= a.exp100000000(-1).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "123456"
		actual	= a.exp100000000(0).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "123456000000000000000000000000"
		actual	= a.exp100000000(3).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(-123456)
		
		expected	= "-123456000000000000000000000000"
		actual	= a.exp100000000(3).toString()
		
		XCTAssertEqual(expected, actual)
}
	
	func testExp10() {
		var a = BigInteger(123456)
		
		var expected	= "1234560"
		var actual		= a.exp10(1).toString()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(123456)
		
		expected	= "12345"
		actual	= a.exp10(-1).toString()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(123456)
		
		expected	= "1"
		actual	= a.exp10(-5).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "0"
		actual	= a.exp10(-6).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "0"
		actual	= a.exp10(-7).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "123456"
		actual	= a.exp10(0).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(123456)
		
		expected	= "1234560000000000"
		actual	= a.exp10(10).toString()
		
		XCTAssertEqual(expected, actual)

		a = BigInteger(-123456)
		
		expected	= "-1234560000000000"
		actual	= a.exp10(10).toString()
		
		XCTAssertEqual(expected, actual)
	}
	
	func testLeastSignificantDigit() {
		var a = BigInteger(123456)
		
		var expected	= 6
		var actual		= a.leastSignificantDigit()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(-123456789)
		
		expected		= 9
		actual		= a.leastSignificantDigit()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(0)
		
		expected		= 0
		actual		= a.leastSignificantDigit()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger(123)
		
		expected		= 3
		actual		= a.leastSignificantDigit()
		
		XCTAssertEqual(expected, actual)
		
		a = BigInteger("128000000000000000000000000000000000000000000000345")!

		expected		= 5
		actual		= a.leastSignificantDigit()
		
		XCTAssertEqual(expected, actual)
	}
}
