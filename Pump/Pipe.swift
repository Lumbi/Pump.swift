//
//  Pipe.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/19/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

// MARK: - Pushable Protocol

// A Pipe than can receive inputs
internal protocol PushablePipe {
	func insert(pipe: PluggablePipe) -> Void // TODO: Find a better name (prepend?)
	func push(event: Event) -> Void
	func flush() -> Void
	func close() -> Void
	func hasSink() -> Bool
	func upstream() -> Flow
}

// MARK: - Pluggable Protocol

// A Pipe than can produce output
internal protocol PluggablePipe {
	func plug<P:PushablePipe>(pipe: P) -> P
	func open() -> Void
	var flow: Flow { get }
}

public typealias Unsubscriber = () -> Void

// A Pipe that takes events as inputs and produces `OutElement` as outputs
public class Pipe<OUT> : PushablePipe, PluggablePipe {
	
	// MARK: - Internal Members
	
	internal var inPipes = [PluggablePipe]()
	internal var outPipes = [PushablePipe]()
	internal var sinks = [Sink]()
	internal var flow = Flow.More
	internal var eventQueue = [Event]()
	
	// MARK: - Public API
	
	public var name: String?
	
	public func subscribe(subscriber: (Event) -> Void) -> Unsubscriber {
		return addSink(Sink(sink: subscriber))
	}
	
	public func onValue(subscriber: (OUT) -> Void) -> Unsubscriber {
		return addSink(Sink.fromValueSinker(subscriber))
	}
	
	public func onError(subscriber: (NSError?) -> Void) -> Unsubscriber {
		return addSink(Sink.fromErrorSinker(subscriber))
	}
	
	public func onEnd(subscriber: () -> Void) -> Unsubscriber {
		return addSink(Sink.fromEndSinker(subscriber))
	}
	
	internal func pipe(event: Event, result: (Event) -> Void) {
		assertionFailure("must implement pipe() func")
		exit(-1)
	}
	
	// MARK: - Callbacks
	
	internal func willFlush() -> Void {}
	
	// MARK: - Composition
	
	internal func insert(pipe: PluggablePipe) {
		self.inPipes.append(pipe)
	}
	
	internal func plug<P:PushablePipe>(pipe: P) -> P {
		self.outPipes.append(pipe)
		pipe.insert(self)
		self.open()
		return pipe
	}
	
	internal func open() {
		self.flush()
		self.inPipes.forEach { $0.open() }
	}
	
	internal func close() {
		self.flush()
		if self.flow == .More {
			let end = End()
			self.pushToAll(end)
			self.sinkToAll(end)
			self.flow = .NoMore
		}
	}
	
	internal func upstream() -> Flow {
		for inPipe in self.inPipes {
			if inPipe.flow == Flow.More {
				return Flow.More
			}
		}
		return Flow.NoMore
	}
	
	// MARK: - Event Handling
	
	internal func push(event: Event) {
		if self.flow == .More {
			self.eventQueue.append(event)
			self.flush()
		}
	}
	
	internal func flush() -> Void {
		self.willFlush()
		self.doFlush()
	}
	
	internal func doFlush() -> Void {
		if self.hasSink() {
			let eventsToFlush = self.eventQueue
			self.eventQueue.removeAll()
			for event in eventsToFlush {
				self.pipe(event, result: { (piped: Event) -> Void in
					switch piped.type {
					case .Next, .Error:
						self.pushToAll(piped)
						self.sinkToAll(piped)
					case .End:
						if self.upstream() == Flow.NoMore {
							self.flow = Flow.NoMore
							let end = End()
							self.pushToAll(end)
							self.sinkToAll(end)
							self.removeAllSinks()
						}
					}
				})
			}
			self.eventQueue.removeAll()
		}	
	}
	
	internal func pushToAll(event: Event) {
		for outPipe in self.outPipes {
			self._log("Pushed", target: outPipe, value: event)
			outPipe.push(event)
		}
	}
	
	internal func sinkToAll(event: Event) {
		for sink in self.sinks {
			self._log("Sank", target: sink, value: event)
			sink.sink(event)
		}
	}
	
	// MARK: - Sink
	
	internal func hasSink() -> Bool {
		return !self.sinks.isEmpty ||
			self.outPipes.reduce(false, combine: { (prev: Bool, pipe: PushablePipe) -> Bool in
				return prev ? true : pipe.hasSink()
			})
	}
	
	internal func addSink(sink: Sink) -> Unsinker {
		_log("Add sink", target: self, value: sink)
		if self.flow == Flow.More {
			sink.unsink = { self.removeSink(sink) }
			self.sinks.append(sink)
			self.open()
			return sink.unsink
		} else {
			sink.sink(End())
			_log("Sank", target: sink, value: End())
			return Pump.nop
		}
	}
	
	internal func removeSink(sink: Sink) {
		self.sinks = self.sinks.filter { $0 != sink }
	}
	
	internal func removeAllSinks() {
		let sinksToRemove = self.sinks
		sinksToRemove.forEach { (sink:Sink) -> () in
			sink.unsink()
		}
		self.sinks.removeAll()
	}
	
	internal func _log(action: Any, target: Any, value: Any) {
		return
		if let name = name {
			print("\(NSDate()) -- \(action)(\(value)) to \(name)")
		} else {
			print("\(NSDate()) -- \(action)(\(value)) to \(target)")
		}
	}
}
