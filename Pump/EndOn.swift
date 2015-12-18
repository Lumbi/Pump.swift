//
//  EndOn.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/17/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func endOnError() -> Pipe<OUT> {
		return self.plug(EndOnPipe<OUT>(shouldEnd: { (event:Event) in event.type == .Error }))
	}
}

internal class EndOnPipe<OUT> : Pipe<OUT> {
	let shouldEnd: (Event) -> Bool
	
	internal init(shouldEnd: (Event) -> Bool) {
		self.shouldEnd = shouldEnd
	}
	
	override func pipe(event: Event, result: (Event) -> Void) {
		if shouldEnd(event) {
			result(End())
		} else {
			result(event)
		}
	}
	
}