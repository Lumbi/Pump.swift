//
//  Concat.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/15/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func concat(other: Pipe<OUT>) -> Pipe<OUT> {
		return self.plug(ConcatPipe(other))
	}
}

internal class ConcatPipe<OUT> : Pipe<OUT> {
	internal let other: Pipe<OUT>
	internal var concat: Bool = false
	
	internal init(_ other: Pipe<OUT>) {
		self.other = other
	}
	
	override func pipe(event: Event, result: (Event) -> Void) {
		if concat {
			result(event)
		} else {
			if event.type == .End {
				concat = true
				other.plug(self)
			} else {
				result(event)
			}
		}
	}
}