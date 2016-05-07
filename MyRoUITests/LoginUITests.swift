//
//  LoginUITests.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import XCTest

class LoginUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFailedLogin() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("user123")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        let loginButton = app.buttons["Client Login Button"]
        loginButton.tap()
        
        // Make sure an error occurred due to invalid login credentials
        self.expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: app.alerts["Authentication Failed"], handler: nil)
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testSuccessfulLogin() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("aadeshp")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("qwer1234")
        let loginButton = app.buttons["Client Login Button"]
        loginButton.tap()
        
        // Wait for server to authenticate
        self.expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: app.textFields["Robot Code"], handler: nil)
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
        // Make sure that it successfully logged in
        XCTAssert(app.buttons["Connect To Robot"].exists)
    }
    
    func testRegistrationWithEmptyFields() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        app.buttons["Sign up now!"].tap()
        
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("newuser123")
        
        app.buttons["Button"].tap()
        
        // Make sure an error occurred since password text fields were empty
        XCTAssert(app.alerts["Error"].exists)
    }
    
    func testRegistrationWithDifferentPasswords() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        app.buttons["Sign up now!"].tap()
        
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("newuser123")
        
        let passwordTextField = app.secureTextFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("password1")
        
        let confirmPasswordTextField = app.secureTextFields["confirm password"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("password2")
        
        app.buttons["Button"].tap()
        
        XCTAssert(app.alerts["Passwords Don't Match"].exists)
    }
    
    func testSuccessfulRegistration() {
        let app = XCUIApplication()
        app.buttons["User Button"].tap()
        app.buttons["Sign up now!"].tap()
        
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("newuser1234567")
        
        let passwordTextField = app.secureTextFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        let confirmPasswordTextField = app.secureTextFields["confirm password"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("password")
        
        app.buttons["Button"].tap()
        
        // Wait for server to process registration
        self.expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: app.alerts["Registered"], handler: nil)
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
