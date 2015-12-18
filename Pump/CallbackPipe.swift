//
//  CallbackPipe.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/9/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

internal class CallbackPipe<OUT>: Pipe<OUT> {
	internal typealias PipeCallback =  (Event, (Event) -> Void) -> Void
	internal let callback: PipeCallback
	
	internal init(callback: PipeCallback) {
		self.callback = callback
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		callback(event, result)
	}
}