//
//  SkipDuplicatesTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/15/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class SkipDuplicatesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testSkipDuplicates1() {
		let expect = self.expectationWithDescription("")
		let inputs:[Int] = [1,1,1,2,2,3,4,4,4,4,5,5,5,5]
		let expected:[Int] = [1,2,3,4,5]
		var result:[Int] = []
		
		let skipDups = Pump.fromArray(inputs).skipDuplicates()

		let _ = skipDups.onValue { (number:Int) -> Void in
			result.append(number)
		}
		let _ = skipDups.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first, result.first)
			XCTAssertEqual(expected.last, result.last)
		}
	}
}
