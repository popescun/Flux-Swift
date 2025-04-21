import XCTest
import OSLog

import Actuator
@testable import Flux_Swift

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Flux_SwiftTests")

final class Flux_SwiftTests: XCTestCase {
   func testStore() throws {
        let storeName = "TEST_STORE"
        var store = BaseStore(name: storeName)
        XCTAssertEqual(store.name, storeName)
        
        Expectation.value = XCTestCase().expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 1
        
        let a = A()
        store.subscribe(callbackName: "A_action", callback: ActuatorBase.Action(action: a.actionWithResult))
        var actuator = store.callbacks["A_action"]!
        XCTAssertNotNil(actuator)
       
        let actionData = ActionData()
        actuator(actionData)
        
        waitForExpectations(timeout: 0)
    }
}

class Expectation {
    public static var value = XCTestExpectation(description: "none")
}

protocol P {
    func action(actionData: ActionData)
    func actionWithResult(actionData: ActionData) -> ActionData
}

struct A: P {
    func action(actionData: ActionData) {
        logger.info("A.action...")
        Expectation.value.fulfill()
    }
    
    func actionWithResult(actionData: ActionData) -> ActionData {
        logger.info("A.actionWithResult...")
        var actionData = ActionData()
        actionData["key1"] = "value1"
        Expectation.value.fulfill()
        return actionData
    }
}
