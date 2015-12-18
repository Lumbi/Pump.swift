//
//  Source.swift
//  Source
//
//  Created by Gabriel Lumbi on 10/19/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public class Source<OutElement> : Stream<OutElement> {
	
	public typealias OUT = OutElement
	
	public override init() {
		super.init()
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		result(event)
	}
	
	public func pump(value: OUT) -> Source<OUT> {
		self.push(Next<OUT>(value))
		return self
	}
	
	public func fail(error: NSError?) {
		self.push(Error(error))
	}
	
	public func deplete() {
		self.push(End())
	}
}