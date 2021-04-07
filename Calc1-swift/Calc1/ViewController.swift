//
//  ViewController.swift
//  Calc1
//
//  Created by Francois Robert on 2016-11-22.
//  Copyright © 2016 Pixtolab. All rights reserved.
//
//  Simple UI for a Calculator
//
import Cocoa

struct OperationData
{
	var a : BigInteger?			= nil
	var b : BigInteger?			= nil
	var result : BigInteger?	= nil
	var textResponse : String? = nil
}

class ViewController: NSViewController {
	
	let megaDecimalAlgo = MegaDecimalAlgo()
	var startTime : DispatchTime? = nil
	
	let errorDivdideByZero  = "Divide by Zero"	// TODO Localize
	let errorCancelled		= "Cancelled"			// TODO Localize
	let errorInvalidA			= "Invalid number A"	// TODO Localize
	let errorInvalidB			= "Invalid number B"	// TODO Localize
	let tooBigForOperation	= "Number too Big for operation"	// TODO Localize
	
	var operationData       = OperationData()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		progressBar.minValue = 0
		progressBar.maxValue = 100
		progressBar.isHidden = true
		progressInderterminateCircle.isHidden = true
		
		megaDecimalAlgo.delegate = self
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBOutlet weak var txtA: NSTextField!
	@IBOutlet weak var txtB: NSTextField!
	@IBOutlet weak var txtRes: NSTextField!
	
	@IBOutlet weak var txtNbDigitsA: NSTextField!
	@IBOutlet weak var txtNbDigitsB: NSTextField!
	@IBOutlet weak var txtNbDigitsRes: NSTextField!
	
	@IBOutlet weak var progressBar: NSProgressIndicator!
	@IBOutlet weak var btnCancel: NSButton!
	@IBOutlet weak var lblTime: NSTextField!
	@IBOutlet weak var progressInderterminateCircle: NSProgressIndicator!

	@IBAction func addButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a + b
		}

		displayResult()
	}
	
	@IBAction func substractButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a - b
		}
		
		displayResult()
	}
	
	@IBAction func multiplyButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a * b
		}
		
		displayResult()
	}
	
	@IBAction func divideButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			do {
				try operationData.result = a / b
			}
			catch BigIntegerError.divideByZero {
				operationData.textResponse = errorDivdideByZero
			}
			catch let error {
				operationData.textResponse = "\(error.localizedDescription)"
			}
		}

		displayResult()
	}
	

	
	@IBAction func moduloButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			do {
				try operationData.result = a % b
			}
			catch BigIntegerError.divideByZero {
				operationData.textResponse = errorDivdideByZero
			}
			catch let error {
				operationData.textResponse = "\(error.localizedDescription)"
			}
		}
		
		displayResult()
	}
	
	@IBAction func factorialButtontapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerAValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a
		{
		
			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
			{
				do
				{
					try self.operationData.result = self.megaDecimalAlgo.factorial(a.toInt())
//					try self.operationData.result = self.megaDecimalAlgo.factorialFast(a.toInt())
				}
				catch MegaDecimalAlgoError.cancelled {
					self.operationData.textResponse = self.errorCancelled
				}
				catch BigIntegerError.tooBigForInt64 {
					self.operationData.textResponse = self.tooBigForOperation
				}
				catch let error {
					self.operationData.textResponse = "\(error.localizedDescription)"
				}
				
				// Back to the main thread to update the UI
				DispatchQueue.main.async {[weak self]
					() -> Void in
					self!.displayResult()
				}
			}
		}
		
		displayResult()
	}
	
	@IBAction func isPrimeButtonTapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerAValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a
		{
			
			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
				{
					do
					{
						try self.operationData.textResponse = self.megaDecimalAlgo.isPrime(a) ? "Yes" : "No"
					}
					catch MegaDecimalAlgoError.cancelled {
						self.operationData.textResponse = self.errorCancelled
					}
					catch let error {
						self.operationData.textResponse = "\(error.localizedDescription)"
					}
					
					// Back to the main thread to update the UI
					DispatchQueue.main.async {[weak self]
						() -> Void in
						self!.displayResult()
					}
			}
		}
		
		displayResult()
	}
	
	@IBAction func previousPrimeButtontapped(_ sender: AnyObject) {
		operationData = OperationData()
		extractBigIntegerAValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a
		{
			
			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
				{
					do
					{
						try self.operationData.result = self.megaDecimalAlgo.smallerOrEqualPrime(a)
					}
					catch MegaDecimalAlgoError.cancelled {
						self.operationData.textResponse = self.errorCancelled
					}
					catch let error {
						self.operationData.textResponse = "\(error.localizedDescription)"
					}
					
					// Back to the main thread to update the UI
					DispatchQueue.main.async {[weak self]
						() -> Void in
						self!.displayResult()
					}
			}
		}
		
		displayResult()
	}
	
	@IBAction func resToAButtonTapped(_ sender: AnyObject) {
		txtA.cell?.title = (txtRes.cell?.title)!
	}
	
	@IBAction func resToBButton(_ sender: AnyObject) {
		txtB.cell?.title = (txtRes.cell?.title)!
	}
	
	@IBAction func cancelButtonTapped(_ sender: AnyObject) {
		megaDecimalAlgo.cancel()
	}
	
	// MARK: - private Helpers
	func prepareOperation()
	{
		// Fresh Data Struct
		operationData = OperationData()
	}
	
	func displayResult()
	{
		// Result
		if let errorOrTextResult = operationData.textResponse
		{
			txtRes.cell?.title			= errorOrTextResult
			txtNbDigitsRes.isHidden    = true
		}
		else if let result = operationData.result
		{
			txtRes.cell?.title			= result.toString()
			txtNbDigitsRes.cell?.title = String(result.digitCount())
			txtNbDigitsRes.isHidden    = false
		}
		else
		{
			txtRes.cell?.title			= ""
			txtNbDigitsRes.isHidden    = true
		}
		
		// A
		if let a = operationData.a
		{
			txtNbDigitsA.cell?.title	= String(a.digitCount())
			txtNbDigitsA.isHidden      = false
		}
		else
		{
			txtNbDigitsA.isHidden      = true
		}
		
		// B
		if let b = operationData.b
		{
			txtNbDigitsB.cell?.title	= String(b.digitCount())
			txtNbDigitsB.isHidden      = false
		}
		else
		{
			txtNbDigitsB.isHidden      = true
		}
	}
	
	private func extractBigIntegerAValue()
	{
		let stringA = txtA.cell?.title
		
		if let a = stringA != nil ? BigInteger(stringA!) : BigInteger(0)
		{
			operationData.a = a
		}
		else
		{
			operationData.textResponse = errorInvalidA
		}
	}
	
	private func extractBigIntegerABValue()
	{
		let stringA = txtA.cell?.title
		let stringB = txtB.cell?.title
		
		if let a = stringA != nil ? BigInteger(stringA!) : BigInteger(0)
		{
			if let b = stringB != nil ? BigInteger(stringB!) : BigInteger(0)
			{
				operationData.a = a
				operationData.b = b
			}
			else
			{
				operationData.a = a
				operationData.textResponse = errorInvalidB
			}
		}
		else
		{
			operationData.textResponse = errorInvalidA
		}
	}
}

extension ViewController : MegaDecimalAlgoDelegate
{
	func algoStarted(withQuantitativeProgression : Bool) {
		startTime = DispatchTime.now()

		DispatchQueue.main.async {[weak self]
			() -> Void in
			if withQuantitativeProgression
			{
				self?.progressBar.isHidden		= false
				self?.progressBar.doubleValue = 0
			}
			else
			{
				self?.progressInderterminateCircle.isHidden		= false
				self?.progressInderterminateCircle.startAnimation(nil)
			}
			self?.txtRes.cell?.title		= ""
		}
	}
	
	func algoEnded() {
		DispatchQueue.main.async {[weak self]
			() -> Void in
			self?.progressBar.doubleValue = 100
			self?.progressBar.isHidden		= true

			self?.progressInderterminateCircle.stopAnimation(nil)
			self?.progressInderterminateCircle.isHidden		= true

			self?.showElapsedTime()
		}
	}
	
	func algoProgressIndeterminate() {
		DispatchQueue.main.async {[weak self]
			() -> Void in
			self?.showElapsedTime()
		}
	}
	
	func algoProgressed(progressPercent: Int) {
		DispatchQueue.main.async {[weak self]
			() -> Void in
			self?.progressBar.doubleValue = Double(progressPercent)
			self?.showElapsedTime()
		}
	}
	
	private func showElapsedTime()
	{
		let end				= DispatchTime.now()
		
		if let start = self.startTime
		{
			let nanoTime		= end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
			let timeInterval	= Double(nanoTime) / 1_000_000_000
			self.lblTime.cell?.title = "\(Int(timeInterval)) s"
		}
		else
		{
			self.lblTime.cell?.title = "???"
		}
	}
}
