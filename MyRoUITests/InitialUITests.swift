//
//  InitialUITests.swift
//  MyRo
//
//  Written by: Aadesh Patel and Nikhil Nelson
//  Tested by: Aadesh Patel and Nikhil Nelson
//

import XCTest

class InitialUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testButtonCounts() {
        let app = XCUIApplication()
        let buttons = app.buttons
        XCTAssertTrue(buttons.count == 2)
    }
    
    func testButtonNames() {
        let app = XCUIApplication()
        let clientButton = app.buttons["User Button"]
        let robotButton = app.buttons["Robot Button"]
        
        XCTAssertNotNil(clientButton)
        XCTAssertNotNil(robotButton)
    }
    
    func testClientTap() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        
        // Check if in LoginViewController
        XCTAssert(app.textFields["Username"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
    }
    
    func testRobotTap() {
        let app = XCUIApplication()
        app.buttons["Robot Button"].tap()
        
        // Check if in RobotViewController
        XCTAssert(app.buttons["End Call"].exists)
    }
}
