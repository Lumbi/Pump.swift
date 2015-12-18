//
//  TakeUntilTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/15/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class TakeUntilTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testTakeUntil1() {
		let expect = self.expectationWithDescription("")
		let input: Int = 10
		let interval: NSTimeInterval = 1
		let expected:[Int] = [10,10]
		var result:[Int] = []
		
		let values = Pump.interval(interval, input)
		let stopper = Pump.fromArray([1,2,3]).delay(2.5)
		let takeUntil = values.takeUntil(stopper)
		
		let _ = takeUntil.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = takeUntil.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(10) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}
	
	func testSequentiallyTakeUntil() {
		let expect = self.expectationWithDescription("")
		let input: [Int] = [1,2,3,4,5,6,7]
		let interval: NSTimeInterval = 1
		let expected:[Int] = [1,2]
		var result:[Int] = []
		
		let takeUntil = Pump.sequentially(interval, input).doLog("sequentially")
			.takeUntil(Pump.fromArray([1,2,3]).delay(2.5))
		
		let _ = takeUntil.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = takeUntil.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(10) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}
}
