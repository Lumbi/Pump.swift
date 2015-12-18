//
//  Flatten.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/25/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func flatten<T>() -> Pipe<T> {
		return self.plug(FlattenPipe<OUT, T>())
	}
}

internal class FlattenPipe<IN, OUT> : Pipe<OUT> {
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		switch event.type {
		case .Next:
			if let next = event as? Next<IN> {
				if let innerPipe = next.value as? PluggablePipe {
					innerPipe.plug(self)
				} else {
					result(next)
				}
			} else {
				result(event)
			}
		case .End, .Error:
			result(event)
		}
	}
}