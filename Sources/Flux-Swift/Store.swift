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
    public var actuators = Dictionary<String, ActuatorBase>()
    
    public init(name: String) {
        self.name = name
    }
    
    public mutating func subscribe(actionName: String, action: ActuatorBase.Action) {
        if !actuators.keys.contains(actionName) {
            actuators[actionName] = ActuatorBase([action])
        } else {
            actuators[actionName]?.add(actions: [action])
        }
    }
    
    // override it in subclass
    public func action(action: ActionData) {
        logger.warning("BaseStore.action: override this method!")
    }
}
