//
//  Pump.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/20/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation


/*
Sinker: a function that takes an Event and may apply some side effects
*/
public typealias Sinker = (Event) -> Void

/*
Binder: a function that takes a Sinker to push it events and returns an unbinder
*/
public typealias Binder = (Sinker) -> Unbinder

/*
Unbinder: A function that frees resources from a binder
*/
public typealias Unbinder = () -> Void

public class Pump {
	
	public static let nop = {}
	
	public static let more = Flow.More
	public static let noMore = Flow.NoMore
	
	public static func never<E>() -> Stream<E> {
		return Stream<E>()
	}
	
	public static func empty<E>() -> Stream<E> {
		let empty = Source<E>()
		empty.deplete()
		return empty
	}
	
	public static func once<E>(value: E) -> Stream<E> {
		let once = Source<E>()
		once.pump(value).deplete()
		return once as Stream<E>
	}
	
	public static func fromBinder<E>(binder: Binder) -> Stream<E> {
		return Stream(bind: binder)
	}
	
	public static func later<E>(delay: NSTimeInterval, _ value: E) -> Stream<E> {
		return Stream(bind: { (sink: Sinker) -> Unbinder in
			var cancel: Bool = false
			Dispatch.after(delay, block: { () -> Void in
				if cancel { return }
				sink(Next(value))
				sink(End())
			})
			return { () -> Void in
				cancel = true
			}
		})
	}
	
	public static func fromArray<E>(array: [E]) -> Stream<E> {
		let fromArray = Source<E>()
		array.forEach { fromArray.pump($0) }
		fromArray.deplete()
		return fromArray as Stream<E>
	}
	
	public static func fromCallback<E>(f: ((E) -> Void) -> Void) -> Stream<E> {
		return Pump.fromBinder({ (sink: Sinker) -> Unbinder in
			let callback = { (value: E) in
				sink(Next(value))
				sink(End())
			}
			f(callback)
			return Pump.nop
		})
	}
	
	public static func fromPoll<E>(interval: NSTimeInterval, f: (inout stop: Bool) -> E) -> Stream<E> {
		return Pump.fromBinder({ (sink: Sinker) -> Unbinder in
			var cancel: (() -> Void)?
			var stop: Bool = false
			cancel = Dispatch.loop(interval, block: { () -> Void in
				let event = f(stop: &stop)
				sink(Next(event))
				if stop {
					sink(End())
					cancel?()
				}
			})
			return cancel!
		})
	}
	
	public static func interval<E>(interval: NSTimeInterval, _ value: E) -> Stream<E> {
		return Pump.fromPoll(interval, f: { (_) -> E in
			return value
		})
	}
	
	public static func sequentially<E>(interval: NSTimeInterval, _ values: [E]) -> Stream<E> {
		if values.isEmpty { return Pump.empty() }
		var index = 0
		return Pump.fromPoll(interval, f: { (inout stop: Bool) -> E in
			let i = index; ++index
			if i >= values.count-1 {
				stop = true
			}
			return values[i]
		})
	}
}

public enum Flow {
	case More
	case NoMore
}