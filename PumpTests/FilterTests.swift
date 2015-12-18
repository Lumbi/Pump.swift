//
//  FilterTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class FilterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testFilter1() {
		let expect = self.expectationWithDescription("")
		let expected:[Int] = [1,2,3,4,5]
		var result:[Int] = []
		let filter = { (number :Int) -> Bool in
			return number >= 3
		}
		let stream = Pump.fromArray(expected).filter(filter)
		let _ = stream.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.filter(filter).count, result.count)
			XCTAssertEqual(expected.filter(filter).first, result.first)
			XCTAssertEqual(expected.filter(filter).last, result.last)
		}
	}
}
