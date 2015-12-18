//
//  Merge.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/9/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func merge(pipe: Pipe<OUT>) -> Pipe<OUT>{
		return Pump.mergeAll([self, pipe])
	}
}