//
//  Log.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/17/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func doLog(tag: String? = nil) -> Pipe<OUT> {
		return self.plug(LogPipe(tag))
	}
}

internal class LogPipe<OUT> : RelayPipe<OUT> {
	let tag: String?
	
	internal init(_ tag: String?) {
		self.tag = tag
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		if let tag = self.tag {
			debugPrint("\(NSDate()) \(tag): \(event)")
		} else {
			debugPrint("\(NSDate()) \(self.inPipes.first): \(event)")
		}
		super.pipe(event, result: result)
	}
}