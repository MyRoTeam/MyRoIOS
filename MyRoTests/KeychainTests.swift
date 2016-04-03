//
//  KeychainTests.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/2/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import XCTest
@testable import MyRo

class KeychainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSharedKeychain() {
        XCTAssertNotNil(KeychainWrapper.sharedKeychain(), "Shared keychain is nil")
    }
    
    func testKeychain() {
        let keychain = KeychainWrapper(group: nil)
        
        let key = "TestKey"
        let data = "TestString".dataUsingEncoding(NSUTF8StringEncoding)
        keychain.setData(data, forKey: key)
        
        let retrievedValue = String(data: keychain.dataForKey(key), encoding: NSUTF8StringEncoding)
        
        XCTAssertNotNil(retrievedValue, "Retrieved value from keychain is nil")
        XCTAssertEqual("TestString", retrievedValue!)
    }
}
