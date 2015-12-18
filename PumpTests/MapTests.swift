//
//  MapTests.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/20/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import XCTest
import Pump

class MapTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testMap() {
		let expect = self.expectationWithDescription("")
		let expected:[String] = ["one","two","three","four","five","six"]
		var result:[Int?] = []
		let stream = Pump.fromArray(expected).map { return $0.characters.count }
		let _ = stream.onValue { (count:Int) -> Void in
			result.append(count)
		}
		let _ = stream.onEnd { () -> Void in
			expect.fulfill()
		}
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first?.characters.count, result.first!)
			XCTAssertEqual(expected.last?.characters.count, result.last!)
		}
	}
	
	func testFlatMapSync1() {
		let expect = expectationWithDescription("")
		let expected: [Int] = [1,2,3,4,5]
		var result = [Int]()

		let flatMapped: Pipe<Int> = Pump.fromArray(expected).flatMap { (number:Int) -> Pipe<Int> in
			return Pump.once(number*2)
		}
		
		let _ = flatMapped.onValue { (value: Int) -> Void in
			result.append(value)
		}
		
		let _ = flatMapped.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first!*2, result.first!)
			XCTAssertEqual(expected.last!*2, result.last!)
		}
	}
	
	func testFlatMapLatest1() {
		let expect = expectationWithDescription("")
		let input: [Int] = [1,2,3]
		let expected: [Int] = [1,1,2,2,3,3,3]
		var result = [Int]()
		
		var innerId = 0
		let flatMappedLatest = Pump.sequentially(1, input).doLog("sequ")
			.flatMapLatest { (next: Int) -> Pipe<Int> in
				innerId++
				return Pump.sequentially(0.4, [next,next,next]).doLog("----> inr\(innerId)")
		}.doLog("-----------> fmap")
		
		let _ = flatMappedLatest.onValue { (value: Int) -> Void in
			result.append(value)
		}
		
		let _ = flatMappedLatest.onEnd { () -> Void in
			expect.fulfill()
		}
		
		waitForExpectationsWithTimeout(15) { (_) -> Void in
			XCTAssertEqual(expected.count, result.count)
			XCTAssertEqual(expected.first!, result.first!)
			XCTAssertEqual(expected.last!, result.last!)
		}
	}
}
