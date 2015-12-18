//
//  MergeAll.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/9/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pump {
	
	public static func mergeAll<E>(pipes: [Pipe<E>]) -> Pipe<E> {
		return MergePipe(pipes)
	}
}

internal class MergePipe<OUT> : RelayPipe<OUT> {
	
	internal init(_ pipes: [Pipe<OUT>]) {
		super.init()
		
		pipes.forEach { (pipe: Pipe<OUT>) -> () in
			pipe.plug(self)
		}
	}
}