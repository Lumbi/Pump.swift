//
//  Buffer.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/16/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public extension Pipe {
	
	public func buffer(withTime time: NSTimeInterval) -> Pipe<[OUT]> {
		return self.plug(BufferPipe<OUT>(time: time))
	}
	
	public func buffer(withCount count: Int) -> Pipe<[OUT]>{
		return self.plug(BufferPipe(count: count))
	}
}

internal class BufferPipe<OUT> : Pipe<[OUT]> {
	internal var buffer = [OUT]()
	internal var capacity: Int = Int.max
	internal var endurance: NSTimeInterval = NSTimeInterval.infinity
	private var beginBufferToken: dispatch_once_t = 0
	private var cancelBufferLoop: (() -> Void)?
	
	internal init(time: NSTimeInterval) {
		assert(time > 0, "Cannot buffer at negative time interval")
		self.endurance = time
	}
	
	internal init(count: Int) {
		assert(count > 0, "Cannot buffer zero elements")
		self.capacity = count
	}
	
	override func pipe(event: Event, result: (Event) -> Void) {
		if let bufferedEvent = event as? BufferedEvent<OUT> {
			result(Next(bufferedEvent.values))
		} else if let next = event as? Next<OUT> {
			buffer.append(next.value)
			if buffer.count >= capacity {
				pushBuffer()
			}
		} else if event.type == .End {
			pushBuffer()
			result(event)
		} else {
			result(event)
		}
	}
	
	internal func startBuffering() {
		if hasSink() {
			Dispatch.once(&beginBufferToken) { () -> Void in
				if self.endurance != NSTimeInterval.infinity {
					self.cancelBufferLoop = Dispatch.loop(self.endurance, block: { () -> Void in
						self.pushBuffer()
					})
				}
			}
		}
	}
	
	internal func endBuffering() {
		cancelBufferLoop?()
		pushBuffer()
	}
	
	internal func pushBuffer() {
		if !buffer.isEmpty {
			let bufferedEvent = BufferedEvent(buffer)
			buffer.removeAll()
			push(bufferedEvent)
		}
	}
	
	override func willFlush() {
		super.willFlush()
		startBuffering()
	}
}

private struct BufferedEvent<Element> : Event {
	private var type: EventType { return EventType.Next }
	private let values: [Element]
	private var hasValue: Bool { get { return true } }
	private func getValue() -> Any! { return values }
	private init(_ values: [Element]) { self.values = values }
	private var description: String { return "Pump.Next<\(values)>" }
}