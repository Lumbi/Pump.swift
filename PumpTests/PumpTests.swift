//
//  PumpTests.swift
//  PumpTests
//
//  Created by Gabriel Lumbi on 10/19/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
@testable import Pump

class PumpTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testOnceValue() {
		let expect = self.expectationWithDescription("")
		let expected: String = "hello"
		var result: String? = nil
		let stream = Pump.once("hello")
		let _ = stream.onValue { (s:String) -> Void in
			result = s
		}
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		self.waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssert(result == expected)
		}
	}
	
	func testLater() {
		let expect = self.expectationWithDescription("")
		let expected: String = "hello"
		var result: String? = nil
		let delay: NSTimeInterval = 2
		let expectedEndTime = NSDate(timeIntervalSinceNow: delay).timeIntervalSinceReferenceDate
		var resultEndTime: NSTimeInterval?
		
		let stream = Pump.later(delay, "hello")
		let _ = stream.onValue { (s:String) -> Void in
			result = s
		}
		let _ = stream.onEnd { () -> Void in
			resultEndTime = NSDate().timeIntervalSinceReferenceDate
			expect.fulfill()
		}
		self.waitForExpectationsWithTimeout(delay*2) { (_) -> Void in
			XCTAssert(result == expected)
			XCTAssertEqualWithAccuracy(expectedEndTime, resultEndTime!, accuracy: 0.5)
		}
	}
	
	func testFromCallback() {
		let expect = self.expectationWithDescription("")
		let expected: Int = 12
		var result: Int?
		let fromCallback = Pump.fromCallback { (callback:(Int) -> Void) -> Void in
			callback(expected)
		}
		let _ = fromCallback.onValue { (val:Int) -> Void in
			result = val
		}
		let _ = fromCallback.onEnd { () -> Void in
			expect.fulfill()
		}
		self.waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssert(result == expected)
		}
	}
	
	func testFromPoll() {
		let expect = self.expectationWithDescription("")
		let expected: [Int] = [1,2,3,4]
		var result = [Int]()
		let interval: NSTimeInterval = 0.5
		var i = 0
		let fromPoll: Stream<Int> = Pump.fromPoll(interval) { (inout stop: Bool) -> Int in
			i++
			if i == expected.count {
				stop = true
			}
			return expected[i-1]
		}
		let _ = fromPoll.onValue { (val:Int) -> Void in
			result.append(val)
		}
		let _ = fromPoll.onEnd { () -> Void in
			expect.fulfill()
		}
		self.waitForExpectationsWithTimeout(10) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}
}
