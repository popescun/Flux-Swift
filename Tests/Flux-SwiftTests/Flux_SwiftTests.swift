import XCTest
import Actuator
import Flux_Swift

final class Flux_SwiftTests: XCTestCase {
    let storeId = "TEST_STORE"
    
    @MainActor func testStoreCreation() throws {
        let store = BaseStore(id: storeId)
        XCTAssertEqual(store.id, storeId)
    }
    
    @MainActor func testStoreSubscribe() throws {
        var store = BaseStore(id: storeId)
        
        store.subscribe(actionName: "action", action: ActuatorBase.Action(action: action))
        var actuator = store.actuators["action"]
        XCTAssertNotNil(actuator)
        XCTAssertTrue(actuator!.isConnected)
        XCTAssertEqual(actuator!.Count, 1)
        
        Expectation.value = expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 1
        
        var actionData = ActionData(id: "ACTION", payload: [:])
        actionData.payload["key"] = "value"
        actuator!(actionData)
        
        waitForExpectations(timeout: 0)
        
        XCTAssertEqual(actionData.payload["key"] as! String, actuator!.Results[0]["key"] as! String)
        //        print(actionData["key"] as! String)
        //        print(actuator!.Results[0]["key"] as! String)
    }
    
    @MainActor func testStoreMultipleSubscribeSameAction() throws {
        var store = BaseStore(id: storeId)
        
        store.subscribe(actionName: "action", action: ActuatorBase.Action(action: action))
        store.subscribe(actionName: "action", action: ActuatorBase.Action(action: action))
        var actuator = store.actuators["action"]
        XCTAssertNotNil(actuator)
        XCTAssertTrue(actuator!.isConnected)
        XCTAssertEqual(actuator!.Count, 2)
        
        Expectation.value = expectation(description: "test store")
        Expectation.value.expectedFulfillmentCount = 2
        
        var actionData = ActionData(id: "ACTION", payload: [:])
        actionData.payload["key"] = "value"
        actuator!(actionData)
        
        waitForExpectations(timeout: 0)
        
        XCTAssertEqual(actionData.payload["key"] as! String, actuator!.Results[0]["key"] as! String)
        XCTAssertEqual(actionData.payload["key"] as! String, actuator!.Results[1]["key"] as! String)
    }
    
    @MainActor func testStoreMultipleSubscribeDifferentActions() throws {
        var store = BaseStore(id: storeId)
        
        store.subscribe(actionName: "action", action: ActuatorBase.Action(action: action))
        store.subscribe(actionName: "action2", action: ActuatorBase.Action(action: action2))
        
        var actuator = store.actuators["action"]
        XCTAssertNotNil(actuator)
        XCTAssertTrue(actuator!.isConnected)
        XCTAssertEqual(actuator!.Count, 1)
        
        var actuator2 = store.actuators["action2"]
        XCTAssertNotNil(actuator2)
        XCTAssertTrue(actuator2!.isConnected)
        XCTAssertEqual(actuator2!.Count, 1)
        
        Expectation.value = expectation(description: "test first actuator")
        Expectation.value.expectedFulfillmentCount = 1
        
        var actionData = ActionData(id: "ACTION", payload: [:])
        actionData.payload["key"] = "value"
        actuator!(actionData)
        
        waitForExpectations(timeout: 0)
        
        XCTAssertEqual(actionData.payload["key"] as! String, actuator!.Results[0]["key"] as! String)
        
        Expectation.value = expectation(description: "test first actuator")
        Expectation.value.expectedFulfillmentCount = 1
        
        actionData.payload["key"] = "value2"
        actuator2!(actionData)
        
        waitForExpectations(timeout: 0)
        
        XCTAssertEqual(actionData.payload["key"] as! String, actuator2!.Results[0]["key"] as! String)
    }
    
    func action(actionData: ActionData) -> Payload {
        var result = Payload()
        result["key"] = actionData.payload["key"]
        Expectation.value.fulfill()
        return result
    }
    
    func action2(actionData: ActionData) -> Payload {
        var result = Payload()
        result["key"] = actionData.payload["key"]
        Expectation.value.fulfill()
        return result
    }
}

class Expectation {
    nonisolated(unsafe) public static var value = XCTestExpectation(description: "none")
}
