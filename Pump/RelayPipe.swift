//
//  RelayPipe.swift
//  Pump
//
//  Created by Gabriel Lumbi on 11/8/15.
//  Copyright © 2015 Lumbi. All rights reserved.
//

import Foundation

internal class RelayPipe<OUT>: Pipe<OUT> {
	
	override func pipe(event: Event, result: (Event) -> Void) {
		result(event)
	}
}