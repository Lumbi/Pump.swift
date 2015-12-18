//
//  Take.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func take(count: UInt) -> Pipe<OUT> {
		if count == 0 { return Pump.empty() }
		return self.plug(TakePipe(count))
	}
}

internal class TakePipe<OUT> : Pipe<OUT> {
	private var count: UInt = 1
	
	internal init(_ count: UInt) {
		super.init()
		assert(count > 0)
		self.count = count
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		if event.type == .Next {
			if count > 0 {
				result(event)
				count--
				if count <= 0 {
					result(End())
				}
			}
		} else {
			result(event)
		}
	}
}
