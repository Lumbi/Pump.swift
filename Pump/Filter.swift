//
//  Filter.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func filter(filter: (OUT) -> Bool) -> Pipe<OUT> {
		return self.plug(FilterPipe(filter: filter))
	}
}

internal class FilterPipe<OUT> : Pipe<OUT> {
	let filter: (OUT) -> Bool
	internal init(filter: (OUT) -> Bool) {
		self.filter = filter
		super.init()
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		switch event.type {
		case .Next:
			let next = event as! Next<OUT>
			if filter(next.value) {
				result(event)
			}
		default:
			result(event)
		}
	}
}