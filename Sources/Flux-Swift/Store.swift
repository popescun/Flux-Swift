//
//  Store.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 16/04/2025.
//

import OSLog
import Actuator

public struct BaseStore {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BaseStore")
    public var name: String = "none"
    public var callbacks = Dictionary<String, ActuatorBase>()
    
    public init(name: String) {
        self.name = name
    }
    
    public mutating func subscribe(callbackName: String, callback: ActuatorBase.Action) {
        if !callbacks.keys.contains(callbackName) {
            callbacks[callbackName] = ActuatorBase([callback])
        } else {
            callbacks[callbackName]?.add(actions: [callback])
        }
    }
    
    // override it in subclass
    public func action(action: ActionData) {
        logger.warning("BaseStore.action: override this method!")
    }
}
