//
//  APIRouteTests.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import XCTest
@testable import MyRo

class APIRouteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserRoutes() {
        XCTAssertEqual(UserServiceRoute.Create.description, "users/")
        XCTAssertEqual(UserServiceRoute.Authenticate.description, "users/login/")
        XCTAssertEqual(UserServiceRoute.Update("TestId").description, "users/TestId/")
        XCTAssertEqual(UserServiceRoute.Connect("TestId").description, "users/TestId/connect/")
        XCTAssertEqual(UserServiceRoute.Get("TestId").description, "users/TestId/")
    }
    
    func testRobotRoutes() {
        XCTAssertEqual(RobotServiceRoute.Create.description, "robots/")
        XCTAssertEqual(RobotServiceRoute.Get("TestId").description, "robots/TestId/")
    }
}
