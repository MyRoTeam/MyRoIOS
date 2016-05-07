//
//  RobotConnectionUITests.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import XCTest

class RobotConnectionUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func login(app: XCUIApplication) {
        app.buttons["User Button"].tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("aadeshp")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("qwer1234")
        let loginButton = app.buttons["Client Login Button"]
        loginButton.tap()
    }
    
    func testInvalidRobotCode() {
        let app = XCUIApplication()
        self.login(app)
        
        let robotCodeTextField = app.textFields["Robot Code"]
        robotCodeTextField.tap()
        robotCodeTextField.typeText("invalidcode123")
        
        app.buttons["Connect Button"].tap()
        
        // Make sure an error occurred
        self.expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: app.alerts["Error"], handler: nil)
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testValidRobotCode() {
        let app = XCUIApplication()
        self.login(app)
        
        let robotCodeTextField = app.textFields["Robot Code"]
        robotCodeTextField.tap()
        robotCodeTextField.typeText("code123")
        
        app.buttons["Connect Button"].tap()
        
        // Make sure NO error occurred
        self.expectationForPredicate(NSPredicate(format: "exists != 1"), evaluatedWithObject: app.alerts["Error"], handler: nil)
        self.waitForExpectationsWithTimeout(3.0, handler: nil)
    }
}
