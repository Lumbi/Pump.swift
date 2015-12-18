//
//  StartWithTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class StartWithTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
	
	func testStartWithSync1() {
		let expect = expectationWithDescription("")
		let input: [Int] = [1,2,3,4,5]
		let expected: [Int] = [99, 1,2,3,4,5]
		var result = [Int]()
		
		let startedWith = Pump.fromArray(input).startWith(99)
		
		let _ = startedWith.onValue { (value: Int) -> Void in
			result.append(value)
		}
		
		let _ = startedWith.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}
}
