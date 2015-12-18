//
//  DelayTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/23/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class DelayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testDelayOnce() {
		let expect = self.expectationWithDescription("")
		let stream = Pump.once("delay").delay(2)
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(3) { (_) -> Void in
			XCTAssert(true)
		}
	}

	func testDelay() {
		let expect = self.expectationWithDescription("")
		let expected:[String] = ["one","two","three","four","five","six"]
		var result:[String?] = []
		let delay: NSTimeInterval = 2
		let expectedEndTime = NSDate(timeIntervalSinceNow: delay).timeIntervalSinceReferenceDate
		var resultEndTime: NSTimeInterval?
		
		let stream = Pump.fromArray(expected).delay(delay)
		
		let _ = stream.onValue { (string:String) -> Void in
			result.append(string)
		}
		
		let _ = stream.onEnd { () -> Void in
			resultEndTime = NSDate().timeIntervalSinceReferenceDate
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(5) { (error: NSError?) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqualWithAccuracy(expectedEndTime, resultEndTime!, accuracy: 0.5)
		}
	}
}
