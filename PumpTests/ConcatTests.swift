//
//  ConcatTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/15/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class ConcatTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testConcat1() {
		let expect = self.expectationWithDescription("")
		let input1: [Int] = [1,2,3]
		let input2: [Int] = [4,5,6,7]
		let expected:[Int] = input1 + input2
		var result:[Int] = []
		
		let concat = Pump.fromArray(input1).concat(Pump.fromArray(input2))
		
		let _ = concat.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = concat.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(5) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}

}
