//
//  ModelCoderTests.swift
//  MyRo
//
//  Written by: Aadesh Patel and Nikhil Nelson
//  Tested by: Aadesh Patel and Nikhil Nelson
//

import XCTest
@testable import MyRo

class ModelCoderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserCoder() {
        let user = User()
        user.id = "TestId"
        user.username = "TestUsername"
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(user)
        let unarchivedUser = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        XCTAssertNotNil(unarchivedUser, "NSKeyedArchiver for User failed")
        
        XCTAssertEqual(user.id, unarchivedUser!.id)
        XCTAssertEqual(user.username, unarchivedUser!.username)
    }
    
    func testRobotCoder() {
        let robot = Robot()
        robot.id = "RobotId"
        robot.name = "TestName"
        robot.code = "TestCode"
        robot.udid = "TestUDID"
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(robot)
        let unarchivedRobot = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Robot
        XCTAssertNotNil(unarchivedRobot, "NSKeyedArchiver for Robot failed")
        
        XCTAssertEqual(robot.id, unarchivedRobot!.id)
        XCTAssertEqual(robot.name, unarchivedRobot!.name)
        XCTAssertEqual(robot.code, unarchivedRobot!.code)
        XCTAssertEqual(robot.udid, unarchivedRobot!.udid)
    }
}
