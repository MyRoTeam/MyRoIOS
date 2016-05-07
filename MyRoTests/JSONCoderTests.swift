//
//  JSONCoderTests.swift
//  MyRo
//
//  Created by Aadesh Patel on 5/7/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import XCTest
@testable import MyRo

class JSONCoderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateJsonCoder() {
        let coder = DateCoder(format: "MM/dd/yyyy")
        var dateStr = "05/01/2016"
        var date = coder.decode(dateStr)!
        
        XCTAssert(date.dateString("MM/dd/yyyy")! == NSDate(month: 5, day: 1, year: 2016).dateString("MM/dd/yyyy")!)
        
        date = NSDate()
        dateStr = coder.encode(date)!
        
        print("DATESTR: \(dateStr)")
        print("DATESTR2: \(date.dateString("MM/dd/yyyy")!)")
        
        XCTAssert(dateStr == date.dateString("MM/dd/yyyy")!)
    }
    
    private enum TestEnum: RawRepresentable {
        case Test1
        case Test2
        
        typealias RawValue = String
        
        init?(rawValue: RawValue) {
            switch(rawValue) {
            case "Test1":
                self = .Test1
            default:
                self = .Test2
            }
        }
        
        private var rawValue: RawValue {
            switch(self) {
            case .Test1:
                return "Test1"
            default:
                return "Test2"
            }
        }
    }
    
    func testEnumJsonCoder() {
        let coder = EnumCoder<TestEnum>()
        let e = TestEnum.Test1
        
        XCTAssert(coder.decode("Test1")! == e)
        XCTAssert(coder.encode(e)! == "Test1")
    }
}
