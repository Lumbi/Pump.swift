//
//  Event.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/19/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public enum EventType {
	case Next
	case Error
	case End
}

public protocol Event: CustomStringConvertible {
	var type: EventType { get }
	var hasValue: Bool { get }
	func getValue() -> Any!
}

public struct Next<Element>: Event {
	public var type: EventType { return EventType.Next }
	public let value: Element
	public var hasValue: Bool { get { return true } }
	public func getValue() -> Any! {
		return value
	}
	public init(_ value: Element) {
		self.value = value
	}
	public var description: String { return "Pump.Next<\(value)>" }
}

public struct End: Event {
	public var type: EventType { return EventType.End }
	public var hasValue: Bool { get { return false } }
	public func getValue() -> Any! { assertionFailure("End events do not have values"); return nil }
	public init() {}
	public var description: String { return "Pump.End" }
}

public struct Error: Event {
	public var type: EventType { return EventType.Error }
	public var hasValue: Bool { get { return false } }
	public func getValue() -> Any! { assertionFailure("Error events do not have values"); return nil }
	public let error: NSError?
	public init(_ error: NSError? = nil) {
		self.error = error
	}
	public var description: String { return "Pump.Error<\(error)>" }
}