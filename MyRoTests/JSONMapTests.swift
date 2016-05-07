//
//  JSONMapTests.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import XCTest
@testable import MyRo

class JSONMapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFromJson() {
        let json = ["name": "TestName"]
        let map = JSONMap(mapping: .From, json: json)
        let _ = map["name"]
        
        XCTAssertEqual(map.value(), json["name"])
        
        var name: String!
        JSONMap.from(&name, value: map.value())
        
        XCTAssertEqual(name, map.value())
    }
    
    func testToJson() {
        let map = JSONMap(mapping: .To, json: [:])
        let _ = map["name"]
        let name = "TestName"
        JSONMap.to(name, map: map)
        let _ = map["name"]

        XCTAssertEqual(map.value(), name)
    }
    
    func testSetValue() {
        let json = ["name": "TestName"]
        let map = JSONMap(mapping: .From, json: json)
        map.setValue("TestValue", forKey: "TestKey")
        let _ = map["TestKey"]
        
        XCTAssertEqual(map.value(), "TestValue")
    }
}
