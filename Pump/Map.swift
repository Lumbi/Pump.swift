//
//  Pipe+Map.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/20/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func map<T>(transform: (OUT) -> T) -> Pipe<T> {
		return self.plug(MapPipe(transform))
	}
	
	public func flatMap<T>(transform: (OUT) -> Pipe<T>) -> Pipe<T> {
		return self.plug(MapPipe(transform)).flatten()
	}
	
	public func flatMap<T>(pipe: Pipe<T>) -> Pipe<T> {
		return self.flatMap({ (_) -> Pipe<T> in return pipe })
	}

	public func flatMapLatest<T>(transform: (OUT) -> Pipe<T>) -> Pipe<T> {
		return self.flatMap({ (next: OUT) -> Pipe<T> in
			return transform(next).takeUntil(self)
		})
	}
	
	public func flatMapLatest<T>(pipe: Pipe<T>) -> Pipe<T> {
		return self.flatMap({ (_) -> Pipe<T> in
			return pipe.takeUntil(self)
		})
	}
}

internal class MapPipe<IN, OUT> : Pipe<OUT> {
	internal typealias Transform = (IN) -> OUT
	private let transform: Transform
	
	internal init(_ transform: Transform) {
		self.transform = transform
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		switch event.type {
		case .Next:
			let next = event as! Next<IN>
			result(Next(transform(next.value)))
		case .Error, .End:
			result(event)
		}
	}
}