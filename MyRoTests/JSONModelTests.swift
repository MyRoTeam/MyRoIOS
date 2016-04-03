//
//  JSONModelTests.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/2/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import XCTest
@testable import MyRo

class JSONModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRobotSerialization() {
        let robot = Robot()
        robot.id = "TestId"
        robot.name = "TestName"
        robot.code = "123456"
        robot.udid = "TestUDID"
        let json = robot.toJSON()
        
        XCTAssertEqual(robot.id, json["_id"] as? String)
        XCTAssertEqual(robot.name, json["name"] as? String)
        XCTAssertEqual(robot.code, json["code"] as? String)
        XCTAssertEqual(robot.udid, json["udid"] as? String)
    }
    
    func testUserSerialization() {
        let user = User()
        user.id = "TestId"
        user.username = "TestUsername"
        let json = user.toJSON()
        
        XCTAssertEqual(user.id, json["_id"] as? String)
        XCTAssertEqual(user.username, json["username"] as? String)
    }
    
    func testUserDeserialization() {
        let json = ["_id": "TestId", "username": "TestUsername"]
        let user = User.fromJSON(json)
        
        XCTAssertEqual(json["_id"], user.id)
        XCTAssertEqual(json["username"], user.username)
    }
    
    func testRobotDeserialization() {
        let json = ["_id": "TestId", "name": "TestName", "code": "123456", "udid": "TestUDID"]
        let robot = Robot.fromJSON(json)
        
        XCTAssertEqual(json["_id"], robot.id)
        XCTAssertEqual(json["name"], robot.name)
        XCTAssertEqual(json["code"], robot.code)
        XCTAssertEqual(json["udid"], robot.udid)
    }
}
