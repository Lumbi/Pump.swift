//
//  StartWith.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func startWith(value: OUT) -> Pipe<OUT> {
		let pipe = RelayPipe<OUT>()
		pipe.push(Next(value))
		return self.plug(pipe)
	}
}