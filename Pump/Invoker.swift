//
//  Invoker.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/12/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

internal class Invoker: NSObject {
	let block: () -> Void
	
	internal init(_ block: () -> Void) {
		self.block = block
	}
	
	internal convenience init(target: AnyObject, selector: Selector) {
		self.init({
			target.performSelector(selector)
		})
	}
	
	internal func invoke() {
		block()
	}
}