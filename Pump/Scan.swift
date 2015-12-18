//
//  Scan.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func scan<T>(seed: T, scan: (T, OUT) -> T) -> Pipe<T> {
		return self.plug(ScanPipe(seed, scan: scan))
	}
}

internal class ScanPipe<IN, OUT> : Pipe<OUT> {
	var acc: OUT
	let scan: (OUT, IN) -> OUT
	
	internal init(_ seed: OUT, scan: (OUT, IN) -> OUT) {
		self.acc = seed
		self.scan = scan
		super.init()
		self.push(Next(seed))
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		if event.type == .Next {
			if let next = event as? Next<IN> {
				self.acc = scan(acc, next.value)
				result(Next(acc))
			}
		} else {
			result(event)
		}
	}
}
