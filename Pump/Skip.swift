//
//  Skip.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func skip(count: UInt) -> Pipe<OUT> {
		if count == 0 { return self }
		var count = count
		return self.plug(SkipPipe({ (event: Event) -> Bool in
			if event.type == .Next {
				if count > 0 {
					count--
					return true
				}
			}
			return false
		}))
	}
	
	public func skipErrors() -> Pipe<OUT> {
		return self.plug(SkipPipe({ $0.type == .Error }))
	}
	
	public func skipDuplicates(equals: (OUT, OUT) -> Bool) -> Pipe<OUT> {
		var last: OUT?
		return self.plug(SkipPipe({ (event: Event) -> Bool in
			if event.type == .Next {
				let next = event as! Next<OUT>
				if last != nil && equals(last!, next.value) {
					return true
				} else {
					last = next.value
				}
			}
			return false
		}))
	}
}

public extension Pipe where OUT : Equatable {
	
	public func skipDuplicates() -> Pipe<OUT> {
		return self.skipDuplicates({ $0 == $1 })
	}
	
	public func unique() -> Pipe<OUT> {
		return self.skipDuplicates()
	}
}

internal class SkipPipe<OUT> : Pipe<OUT> {
	private var skip: (Event) -> Bool
	
	internal init(_ skip: (Event) -> Bool) {
		self.skip = skip
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		if !skip(event) {
			result(event)
		}
	}
}
