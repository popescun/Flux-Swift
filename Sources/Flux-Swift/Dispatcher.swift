//
//  Dispatcher.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 16/04/2025.
//

import OSLog
import Actuator

public class Dispatcher {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BaseStore")
    var actuator = Actuator1<Void, ActionData>()
    
    public init(stores: [BaseStore]) {
        for store in stores {
            actuator.add(actions: [Actuator1.Action(action: store.action)])
        }
    }
    
    public func dispatchAction(actionData: ActionData) {
        logger.warning("Dispatcher::dispatchAction from \(actionData.from) to \(actionData.to)")
        actuator(actionData)
    }
}
