//
//  IntegerListTests.swift
//  IntegerListTests
//
//  Created by Francois Robert on 2016-11-22.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import XCTest
@testable import Calc1

class IntegerListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBase01() {
		
		let integerList = IntegerList()
		
		XCTAssertEqual(integerList.count, 0)
		XCTAssertEqual(integerList.description, "0")
    }

	func testBase02() {
		
		let integerList = IntegerList()
		_ = integerList.add(123); _ = integerList.add(345)
		
		XCTAssertEqual(integerList.count, 2)
		XCTAssertEqual(integerList.description, "123;345")
		
		_ = integerList.add(1); _ = integerList.add(2)

		XCTAssertEqual(integerList.count, 4)
		XCTAssertEqual(integerList.description, "123;345;1;2")
		
		integerList.empty()
		XCTAssertEqual(integerList.count, 0)
		XCTAssertEqual(integerList.description, "0")
	}

	func testCount() {

		let integerList = IntegerList()

		var expected = 0
		var actual = integerList.count
		
		XCTAssertEqual(expected, actual)
		
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4)
		
		expected = 4
		actual = integerList.count

		XCTAssertEqual(expected, actual)
	}
	
	func testSetAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4)

		integerList.setAt(0, value: 322)
		XCTAssertEqual(integerList.description, "322;2;3;4")

		integerList.setAt(3, value: 11)
		XCTAssertEqual(integerList.description, "322;2;3;11")

		integerList[1] = 123
		XCTAssertEqual(integerList.description, "322;123;3;11")
		
		integerList[0] = 42
		XCTAssertEqual(integerList.description, "42;123;3;11")
}
	
	func testRemoveAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		integerList.removeAt(0)
		XCTAssertEqual(integerList.description, "2;3;4;5;6")

		integerList.removeAt(3)
		XCTAssertEqual(integerList.description, "2;3;4;6")

		integerList.removeAt(3)
		XCTAssertEqual(integerList.description, "2;3;4")
	}
	
	func testGetAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)
	
		XCTAssertEqual(integerList.getAt(2), 3)
		XCTAssertEqual(integerList.getAt(0), 1)
		XCTAssertEqual(integerList.getAt(5), 6)

		XCTAssertEqual(integerList[2], 3)
		XCTAssertEqual(integerList[0], 1)
		XCTAssertEqual(integerList[5], 6)
}

	func testAdd() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)
		
		let expected = 6
		let actual = integerList.add(322)
		XCTAssertEqual(expected, actual)
		
		XCTAssertEqual(integerList.description, "1;2;3;4;5;6;322")
	}
	
	func testInsertRange() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		let subList = IntegerList()
		_ = subList.add(11); _ = subList.add(12); _ = subList.add(13);

		integerList.insertRange(atIndex: 0, arrayToInsert: subList)
		XCTAssertEqual(integerList.description, "11;12;13;1;2;3;4;5;6")

		integerList.insertRange(atIndex: 8, arrayToInsert: subList)
		XCTAssertEqual(integerList.description, "11;12;13;1;2;3;4;5;11;12;13;6")
	}
	
	func testRemoveRange() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)
		
		integerList.removeRange(atIndex: 3, count: 2)
		XCTAssertEqual(integerList.description, "1;2;3;6")
		
		integerList.removeRange(atIndex: 0, count: 2)
		XCTAssertEqual(integerList.description, "3;6")
	}
}
