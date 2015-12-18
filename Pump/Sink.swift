//
//  Sink.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/19/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

internal typealias ErrorSinker = (NSError?) -> Void
internal typealias EndSinker = () -> Void
internal typealias Unsinker = () -> Void

internal func == (lhs: Sink, rhs: Sink) -> Bool {
	return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

internal class Sink: Equatable, CustomStringConvertible {
	
	let sink: Sinker
	var unsink: Unsinker = Pump.nop
	let name: String?
	
	internal init(sink: Sinker, name: String? = nil) {
		self.name = name
		self.sink = sink
	}
	
	class func fromValueSinker<T>(sinkValue: (T) -> Void) -> Sink {
		return Sink(sink: { (event: Event) in
			if event.type == .Next {
				let next = event as! Next<T>
				sinkValue(next.value)
			}
			}, name: "value")
	}
	
	class func fromErrorSinker(sinkError: ErrorSinker) -> Sink {
		return Sink(sink: { (event: Event) -> Void in
			if event.type == .Error {
				let error = event as! Error
				sinkError(error.error)
			}
			}, name: "error")
	}
	
	class func fromEndSinker(sinkEnd: EndSinker) -> Sink {
		return Sink(sink: { (event: Event) -> Void in
			if event.type == .End {
				sinkEnd()
			}
			}, name: "end")
	}
	
	var description: String {
		if let name = self.name {
			return "Pump.Sink<\(name)>"
		} else {
			return "Pump.Sink"
		}
	}
}