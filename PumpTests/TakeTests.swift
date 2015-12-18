//
//  TakeTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class TakeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testTake1() {
		let expect = self.expectationWithDescription("")
		let expected:[Int] = [1,2,3,4,5]
		var result:[Int] = []
		let stream = Pump.fromArray(expected).take(1)
		let _ = stream.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(1, result.count)
			XCTAssertEqual(expected.first, result.first)
		}
	}
	
	func testTakeAll() {
		let expect = self.expectationWithDescription("")
		let expected:[Int] = [1,2,3,4,5]
		var result:[Int] = []
		let stream = Pump.fromArray(expected).take(5)
		let _ = stream.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}

}
