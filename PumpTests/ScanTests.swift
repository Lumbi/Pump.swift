//
//  ScanTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class ScanTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testScanSync1() {
		let expect = expectationWithDescription("")
		let input: [Int] = [1,2,3,4,5]
		let expected = input.reduce(0, combine: { (sum:Int, i:Int) -> Int in
			return sum + i
		})
		var result: Int = -999
		
		let scanned: Pipe<Int> = Pump.fromArray(input).scan(0) { (sum:Int, i:Int) -> Int in
			return sum + i
		}
		
		let _ = scanned.onValue { (value: Int) -> Void in
			result = value
		}
		
		let _ = scanned.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected, result)
		}
	}
}
