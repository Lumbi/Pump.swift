//
//  BufferTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/16/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class BufferTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testBufferCount1() {
		let expect = self.expectationWithDescription("")
		let input: [Int] = [1,2,3,4,5,6,7,8,9]
		let expected: [[Int]] = [[1,2],[3,4],[5,6],[7,8],[9]]
		var result:[[Int]] = []
		let buffer = Pump.fromArray(input).buffer(withCount: 2)
		let _ = buffer.onValue { (numbers:[Int]) -> Void in
			result.append(numbers)
		}
		let _ = buffer.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first!.count, result.first!.count)
			XCTAssertEqual(expected.last!.count, result.last!.count)
		}
	}
	
	func testBufferCountEmpty() {
		let expect = self.expectationWithDescription("")
		let input: [Int] = []
		var result:[[Int]] = []
		let buffer = Pump.fromArray(input).buffer(withCount: 2)
		let _ = buffer.onValue { (numbers:[Int]) -> Void in
			result.append(numbers)
		}
		let _ = buffer.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssert(result.isEmpty)
		}
	}
	
	func testBufferTime1() {
		let expect = self.expectationWithDescription("")
		let input: [Int] = [1,2,3,4,5,6,7,8,9]
		let expected: [[Int]] = [[1,2],[3,4],[5,6],[7,8],[9]]
		var result:[[Int]] = []
		let interval: NSTimeInterval = 1
		
		let buffer = Pump.sequentially(interval, input).buffer(withTime: (2*interval)+0.1)

		let _ = buffer.onValue { (numbers:[Int]) -> Void in
			result.append(numbers)
		}
		let _ = buffer.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(15) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first!.count, result.first!.count)
			XCTAssertEqual(expected.last!.count, result.last!.count)
		}
	}
}
