//
//  Throttle.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/16/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func throttle(delay: NSTimeInterval) -> Pipe<OUT> {
		return self.buffer(withTime: delay).map { $0.last! }
	}
}