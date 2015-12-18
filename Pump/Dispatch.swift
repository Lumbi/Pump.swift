//
//  Dispatch.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

internal class Dispatch {
	
	internal static func once(inout token: dispatch_once_t, block: () -> Void) {
		dispatch_once(&token, block)
	}
	
	internal static func after(delay: NSTimeInterval, block: () -> Void) {
		dispatch_after(
			dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
			dispatch_get_main_queue(),
			block)
	}
	
	internal static func loop(interval: NSTimeInterval, block: () -> Void) -> () -> Void {
		let invoker: Invoker = Invoker(block)
		let timer = NSTimer.scheduledTimerWithTimeInterval(interval,
			target: invoker,
			selector: Selector("invoke"),
			userInfo: nil,
			repeats: true)
		return {
			timer.invalidate()
		}
	}
}