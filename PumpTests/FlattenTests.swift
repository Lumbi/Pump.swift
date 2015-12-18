//
//  FlattenTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/28/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class FlattenTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testFlattenSync1() {
		let expect = expectationWithDescription("")
		let expected: [Int] = [1,2,3,4,5]
		var result = [Int]()
		
		let children: [Stream<Int>] = [
			Pump.once(expected[0]),
			Pump.once(expected[1]),
			Pump.once(expected[2]),
			Pump.once(expected[3]),
			Pump.once(expected[4])
		]
		let flattened: Pipe<Int> = Pump.fromArray(children).flatten()
		
		let _ = flattened.onValue { (value: Int) -> Void in
			result.append(value)
		}
		
		let _ = flattened.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first!)
			XCTAssertEqual(expected.last, result.last!)
		}
	}
	
	func testFlattenAsync1() {
		let expect = expectationWithDescription("")
		let expected: [Int] = [1,2,3,4,5]
		let expectedDelays: [NSTimeInterval] = [1,2,3,4,5]
		let expectedEndTime: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate + expectedDelays.last!
		var result = [Int]()
		var resultEndTime: NSTimeInterval?
		
		let children: [Stream<Int>] = [
			Pump.later(expectedDelays[0], expected[0]),
			Pump.later(expectedDelays[1], expected[1]),
			Pump.later(expectedDelays[2], expected[2]),
			Pump.later(expectedDelays[3], expected[3]),
			Pump.later(expectedDelays[4], expected[4])
		]
		let flattened: Pipe<Int> = Pump.fromArray(children).flatten()
		
		let _ = flattened.onValue { (value: Int) -> Void in
			result.append(value)
		}
		
		let _ = flattened.onEnd { () -> Void in
			resultEndTime = NSDate().timeIntervalSinceReferenceDate
			expect.fulfill()
		}

		waitForExpectationsWithTimeout(expectedDelays.last! + 1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
			XCTAssertEqualWithAccuracy(expectedEndTime, resultEndTime!, accuracy: 1)
		}
	}
}
