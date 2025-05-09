//
//  DispatcherTests.swift
//  Flux-Swift
//
//  Created by Nicolae Popescu on 01/05/2025.
//

import XCTest
import Actuator
import Flux_Swift

final class DispatcherTests: XCTestCase {
    let storeId = "TEST_STORE"
    
    @MainActor func testDispatcherCreation() throws {
        let store = BaseStore(id: storeId)
        XCTAssertNotNil(store)
        let dispatcher = Dispatcher(stores: [store])
        XCTAssertNotNil(dispatcher)
    }
    
    @MainActor func testDispatchAction() throws {
        let store = MyStore(id: storeId)
        let dispatcher = Dispatcher(stores: [store])
        
        Expectation.value = expectation(description: "test dispatch action")
        Expectation.value.expectedFulfillmentCount = 1
        
        var actionData = ActionData(id: "ACTION", from: "TEST", to: "TEST_STORE", payload: [:])
        actionData.payload["key"] = "value"
        dispatcher.dispatchAction(actionData: actionData)
        
        waitForExpectations(timeout: 0)
    }
}

class MyStore : BaseStore {
    override func action(actionData: ActionData) {
        Expectation.value.fulfill()
    }
}
