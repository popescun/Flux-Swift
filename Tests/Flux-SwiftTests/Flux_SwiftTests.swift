import XCTest
import OSLog

import Actuator
import Flux_Swift

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Flux_SwiftTests")

final class Flux_SwiftTests: XCTestCase {
    @MainActor func testStore() throws {
        let storeName = "TEST_STORE"
        var store = BaseStore(name: storeName)
        XCTAssertEqual(store.name, storeName)
        
        store.subscribe(actionName: "actionWithResult", action: ActuatorBase.Action(action: actionWithResult))
        var actuator = store.actuators["actionWithResult"]
        XCTAssertNotNil(actuator)
        
        Expectation.value = expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 1
        
        let actionData = ActionData()
        actuator?(actionData)
        
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
