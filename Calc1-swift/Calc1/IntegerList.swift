//
//  IntegerList.swift
//  Calc1
//
//  Created by Francois Robert on 2016-11-22.
//  Copyright © 2016 Pixtolab. All rights reserved.
//
//  The IntegerList is a data structure that hold the content of a number and that can be implemented in multiple Languages.

import Foundation

public class IntegerList
{
	fileprivate var mIntList = [Int]()
	
	func empty()
	{
		mIntList = [Int]()
	}
	
	func add(_ pValue : Int) -> Int
	{
		mIntList.append(pValue)
		return count - 1          // We return the index at which the value has been added
	}
	
	func getAt(_ pIndex : Int) -> Int
	{
		guard count > 0 else {
			return 0
		}
		
		assert(pIndex < count)
		return mIntList[pIndex]
	}
	
	func setAt(_ pIndex : Int, value pValue : Int)
	{
		assert(pIndex >= 0)
		assert(pIndex < count)
		
		precondition(pIndex >= 0 && pIndex < count)
		
		mIntList[pIndex] = pValue
	}
	
	func removeAt(_ pIndex : Int)
	{
		assert(pIndex >= 0)
		assert(pIndex < count)
		
		precondition(pIndex >= 0 && pIndex < count)

		mIntList.remove(at: pIndex)
	}
	
	func insertRange(atIndex pIndex : Int, arrayToInsert pIntArrayToInsert: IntegerList)
	{
		assert(pIndex < count)
		guard pIndex < count else {
			return
		}
		
		mIntList.insert(contentsOf:pIntArrayToInsert, at: pIndex)
	}
	
	func removeRange(atIndex pIndex : Int, count pCountToRemove: Int)
	{
		assert(pIndex < count);
		assert(pIndex + pCountToRemove <= count);
		
		guard pIndex < count && pIndex + pCountToRemove <= count && pCountToRemove > 0 else {
			return
		}
		
		mIntList.removeSubrange(pIndex..<pIndex+pCountToRemove)
	}
}

extension IntegerList : CustomStringConvertible
{
	public var description:String {
		let stringArray = mIntList.map{ String($0) }
		return count == 0 ? "0" : stringArray.joined(separator:";")
	}
}

extension IntegerList : Sequence
{
	public func makeIterator() -> IndexingIterator<[Int]> {
		return mIntList.makeIterator()
	}
	
}

extension IntegerList : Collection
{
	public subscript(index: Int) -> Int {
		get {
			return mIntList[index]
		}
		
		set {
			mIntList[index] = newValue
		}
	}
	
	public var count: Int {
		get {
			return mIntList.count
		}
	}
	
	public var startIndex: Int {
		return 0
	}
	
	public var endIndex: Int {
		return count
	}
	
	public func index(after i: Int) -> Int
	{
		return mIntList.index(after: i)
	}
}

