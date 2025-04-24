//
//  Action.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 19/04/2025.
//

import Actuator

public typealias Payload = Dictionary<String, Any>

public struct ActionData {
    public var id : String
    public var payload : Payload
    
    public init(id: String = "none", payload: Payload) {
        self.id = id
        self.payload = payload
    }
}

public typealias ActuatorBase = Actuator1<Payload, ActionData>

