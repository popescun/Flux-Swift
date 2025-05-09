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
    public var from : String
    public var to: String
    public var payload : Payload
    
    public init(id: String = "none", from: String, to: String, payload: Payload) {
        self.id = id
        self.from = from
        self.to = to
        self.payload = payload
    }
}

public typealias BaseActuator = Actuator1<Payload, ActionData>

