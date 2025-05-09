//
//  Store.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 16/04/2025.
//

import OSLog
import Actuator

open class BaseStore {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BaseStore")
    public var id: String = "none"
    public var actuators = Dictionary<String, BaseActuator>()
    
    public init(id: String) {
        self.id = id
    }
    
    public func subscribe(actionName: String, action: BaseActuator.Action) {
        if !actuators.keys.contains(actionName) {
            actuators[actionName] = BaseActuator([action])
        } else {
            actuators[actionName]?.add(actions: [action])
        }
    }
    
    // override it in subclass
    open func action(actionData: ActionData) {
        logger.warning("BaseStore.action: override this method!")
    }
}
