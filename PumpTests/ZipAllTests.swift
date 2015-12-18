//
//  ZipAllTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/10/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class ZipAllTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testZipAllSync1() {
		let expect = expectationWithDescription("")
		let input1 = [1,2,3,4,5,6]
		let input2 = ["one", "two", "three", "four"]
		let input3 = [1.1, 2.2, 3.3]
		let expected = [
			(input1[0], input2[0], input3[0]),
			(input1[1], input2[1], input3[1]),
			(input1[2], input2[2], input3[2])
		]
		var result = [(Int, String, Double)]()
		
		let pipe1 = Pump.fromArray(input1)
		let pipe2 = Pump.fromArray(input2)
		let pipe3 = Pump.fromArray(input3)
		
		let zipped = Pump.zipAll(pipe1, pipe2, pipe3)
		
		let _ = zipped.onValue { (i: Int, s:String, d:Double) -> Void in
			result.append((i, s, d))
		}
		
		let _ = zipped.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first!.0, result.first!.0)
			XCTAssertEqual(expected.first!.1, result.first!.1)
			XCTAssertEqual(expected.first!.2, result.first!.2)
			XCTAssertEqual(expected.last!.0, result.last!.0)
			XCTAssertEqual(expected.last!.1, result.last!.1)
			XCTAssertEqual(expected.last!.2, result.last!.2)
		}
	}
}
