//
//  Stream.swift
//  Pump
//
//  Created by Gabriel Lumbi on 10/23/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

public class Stream<OutElement>: Pipe<OutElement> {
	public typealias OUT = OutElement
	
	public override init() {
		super.init()
	}
	
	// MARK: - Bind
	// TODO: what to do with unbinder?
	
	internal var lazyBinder: Binder?
	
	public init(bind: Binder) {
		super.init()
		if hasSink() {
			_ = bind {self.push($0) }
		} else {
			self.lazyBinder = bind
		}
	}
	
	internal override func pipe(event: Event, result: (Event) -> Void) {
		result(event)
	}
	
	internal override func willFlush() {
		if let bind = self.lazyBinder {
			self.lazyBinder = nil
			_ = bind { self.push($0) }
		}
	}
}