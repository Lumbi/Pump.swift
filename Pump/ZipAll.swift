//
//  Zip.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

let lol = [
	Pipe<String>(),
	Pipe<Int>(),
	Pipe<Double?>()
]

let typed = Pipe<String>()
let casted = typed as PluggablePipe

public extension Pump {

	public static func zipAll<A,B>(a: Pipe<A>, _ b: Pipe<B>)
		-> Pipe<(A,B)>
	{
		return ZipPipe(pipes: [a, b], zip: { (events: [Event]) -> (A,B) in
			let a = events[0] as! Next<A>
			let b = events[1] as! Next<B>
			return (a.value, b.value)
		})
	}
	
	public static func zipAll<A,B,C>(a: Pipe<A>, _ b: Pipe<B>, _ c: Pipe<C>)
		-> Pipe<(A,B,C)>
	{
		return ZipPipe(pipes: [a, b, c], zip: { (events: [Event]) -> (A,B,C) in
			let a = events[0] as! Next<A>
			let b = events[1] as! Next<B>
			let c = events[2] as! Next<C>
			return (a.value, b.value, c.value)
		})
	}
	
	public static func zipAll<A,B,C,D>(a: Pipe<A>, _ b: Pipe<B>, _ c: Pipe<C>, _ d: Pipe<D>)
		-> Pipe<(A,B,C,D)>
	{
		return ZipPipe(pipes: [a, b, c, d], zip: { (events: [Event]) -> (A,B,C,D) in
			let a = events[0] as! Next<A>
			let b = events[1] as! Next<B>
			let c = events[0] as! Next<C>
			let d = events[1] as! Next<D>
			return (a.value, b.value, c.value, d.value)
		})
	}
	
	public static func zipAll(pipes: NSArray) -> Pipe<[Any!]> {
		return ZipPipe(pipes: pipes, zip: { (events: [Event]) -> [Any!] in
			return events.map { (event: Event) -> Any! in
				return event.getValue()
			}
		})
	}
}

internal class ZipPipe<OUT>: Pipe<OUT> {
	internal let zip: ([Event]) -> OUT
	internal var callbacks = [CallbackPipe<Void>]()
	internal var buffers: [[Event]]
	
	internal init(pipes: NSArray, zip: ([Event]) -> OUT) {
		assert(pipes.count > 0, "Need more than one pipe to zip")
		self.buffers = pipes.map { _ in [Event]() }
		self.zip = zip
		
		super.init()
		
		var k: Int = 0
		self.callbacks = pipes.map { (pipe: AnyObject) -> CallbackPipe<Void> in
			let i = k; k++
			let pipe = pipe as! PluggablePipe
			let callback = CallbackPipe<Void>(callback: { [weak self] (event: Event, result: (Event) -> Void) -> Void in
				self?.buffers[i].append(event)
				result(event)
			})
			pipe.plug(callback)
			callback.plug(self)
			return callback
		}
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		switch event.type {
		case .Next:
			let latests = buffers.map { $0.first }.filter { $0 != nil }.map { $0! }
			if latests.count == self.buffers.count {
				let value = zip(latests)
				result(Next(value))
				for var i = 0; i < self.buffers.count; i++ {
					self.buffers[i].removeFirst()
				}
			}
		case .Error, .End:
			result(event)
		}
	}
}
