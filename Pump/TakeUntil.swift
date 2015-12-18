//
//  TakeUntil.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/15/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func takeUntil<T>(stopper: Pipe<T>) -> Pipe<OUT> {
		return self.plug(TakeUntilPipe<OUT>(stopper))
	}
}

internal class TakeUntilPipe<OUT> : RelayPipe<OUT> {
	private var callback: CallbackPipe<OUT>!
	
	internal init(_ stopper: PluggablePipe) {
		super.init()
		self.callback = CallbackPipe<OUT>(callback: { (event:Event, _) -> Void in
			if event.type == .Next || event.type == .End {
				self.close()
			}
		})
		stopper.plug(callback)
		callback.plug(self)
	}
}