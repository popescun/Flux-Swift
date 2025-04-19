//
//  Store.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 16/04/2025.
//

import OSLog
import Actuator

struct BaseStore {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BaseStore")
    var name: String = "none"
    var callbacks: Dictionary<String, ActuatorBase>
    
    mutating func subscribe(callbackName: String, callback: ActuatorBase.Action) {
        if !callbacks.keys.contains(callbackName) {
            callbacks[callbackName] = ActuatorBase([callback])
        } else {
            callbacks[callbackName]?.add(actions: [callback])
        }
    }
    
    func action(action: ActionData) {
        logger.warning("BaseStore.action: override this method!")
    }
}
