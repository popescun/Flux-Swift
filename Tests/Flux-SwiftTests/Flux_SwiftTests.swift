import XCTest
import OSLog

import Actuator
import Flux_Swift

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Flux_SwiftTests")

final class Flux_SwiftTests: XCTestCase {
    let storeName = "TEST_STORE"
    
    @MainActor func testStoreCreation() throws {
        var store = BaseStore(name: storeName)
        XCTAssertEqual(store.name, storeName)
    }
    
    @MainActor func testStoreSubscribe() throws {
        var store = BaseStore(name: storeName)
        
        store.subscribe(actionName: "actionWithResult", action: ActuatorBase.Action(action: actionWithResult))
        var actuator = store.actuators["actionWithResult"]
        XCTAssertNotNil(actuator)
        XCTAssertTrue(actuator!.isConnected)
        XCTAssertEqual(actuator!.Count, 1)
        
        Expectation.value = expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 1
        
        let actionData = ActionData()
        actuator!(actionData)
        
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testStoreMultipleSubscribeSameAction() throws {
        let storeName = "TEST_STORE"
        var store = BaseStore(name: storeName)
        XCTAssertEqual(store.name, storeName)
        
        store.subscribe(actionName: "actionWithResult", action: ActuatorBase.Action(action: actionWithResult))
        store.subscribe(actionName: "actionWithResult", action: ActuatorBase.Action(action: actionWithResult))
        var actuator = store.actuators["actionWithResult"]
        XCTAssertNotNil(actuator)
        XCTAssertTrue(actuator!.isConnected)
        XCTAssertEqual(actuator!.Count, 2)
        
        Expectation.value = expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 2
        
        let actionData = ActionData()
        actuator!(actionData)
        
        waitForExpectations(timeout: 0)
    }
    
    func action(actionData: ActionData) {
        logger.info("action...")
        Expectation.value.fulfill()
    }
    
    func actionWithResult(actionData: ActionData) -> ActionData {
        logger.info("actionWithResult...")
        var actionData = ActionData()
        actionData["key1"] = "value1"
        Expectation.value.fulfill()
        return actionData
    }
}

class Expectation {
    nonisolated(unsafe) public static var value = XCTestExpectation(description: "none")
}
