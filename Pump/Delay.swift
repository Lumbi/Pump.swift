//
//  Delay.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/23/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func delay(delay: NSTimeInterval) -> Pipe<OUT> {
		return self.plug(DelayPipe<OUT>(delay))
	}
}

internal class DelayPipe<OUT>: Pipe<OUT> {
	let delay: NSTimeInterval
	
	internal init(_ delay: NSTimeInterval) {
		self.delay = delay
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		switch event.type{
		case .Next, .End:
			Dispatch.after(delay, block: { () -> Void in
				result(event)
			})
		case .Error:
			result(event)
		}
	}
}