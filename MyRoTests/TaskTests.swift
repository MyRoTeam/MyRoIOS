//
//  TaskTests.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import XCTest
@testable import MyRo

class TaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func successTask() -> Task<String> {
        let manager = TaskManager<String>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(2.0)
            manager.complete("Completed")
        }
        
        return manager.task
    }
    
    func testSuccessTask() {
        var thenReached: Bool = false
        var errorReached: Bool = false
        
        self.successTask().then(.Current) { ret in
            thenReached = true
            XCTAssertEqual(ret, "Completed")
        }.error { (error: NSError) in
            errorReached = true
        }.finally {
            XCTAssertTrue(thenReached)
            XCTAssertFalse(errorReached)
        }
    }
    
    func errorTask() -> Task<String> {
        let manager = TaskManager<String>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(2.0)
            manager.completeWithError(NSError(domain: "Task Error", code: 0, userInfo: nil))
        }
        
        return manager.task
    }
    
    func testErrorTask() {
        var thenReached: Bool = false
        var errorReached: Bool = false

        self.errorTask().then(.Current) { ret in
            thenReached = true
        }.error { (error: NSError) in
            errorReached = true
            XCTAssertEqual(error.domain, "Task Error")
        }.finally {
            XCTAssertFalse(thenReached)
            XCTAssertTrue(errorReached)
        }
    }
    
    
    func task1() -> Task<String> {
        let manager = TaskManager<String>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(1.0)
            manager.complete("Completed Task 1")
        }
        
        return manager.task
    }
    
    func task2() -> Task<String> {
        let manager = TaskManager<String>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(1.0)
            manager.complete("Completed Task 2")
        }
        
        return manager.task
    }
    
    func testTaskChaining() {
        var then1Reached: Bool = false
        var then2Reached: Bool = false
        var errorReached: Bool = false
        
        self.task1().then(.Current) { ret -> Int in
            then1Reached = true
            XCTAssertEqual(ret, "Completed Task 1")
            
            return 1
        }.then { ret in
            then2Reached = true
            XCTAssertEqual(ret, 1)
        }.error { (error: NSError) in
            errorReached = true
        }.finally {
            XCTAssertTrue(then1Reached)
            XCTAssertTrue(then2Reached)
            XCTAssertFalse(errorReached)
        }
    }
    
    func testSameTaskTypeJoin() {
        var thenReached: Bool = false
        var errorReached: Bool = false
        
        Task.join(self.task1(), self.task2()).then(.Current) {
            thenReached = true
        }.error { (error: NSError) in
            errorReached = true
        }.finally {
            XCTAssertTrue(thenReached)
            XCTAssertFalse(errorReached)
        }
    }
    
    func testTaskThread() {
        var then1Reached: Bool = false
        var then2Reached: Bool = false
        var then3Reached: Bool = false
        
        let q = dispatch_queue_create("com.myro.task-test", nil)
        self.task1().then(.Current, { _ in
            XCTAssertFalse(NSThread.isMainThread())
            then1Reached = true
        }).then(.Main, {
            XCTAssertTrue(NSThread.isMainThread())
            then2Reached = true
        }).then(.Queue(q), {
            XCTAssertFalse(NSThread.isMainThread())
            then3Reached = true
        }).finally {
            XCTAssertTrue(then1Reached)
            XCTAssertTrue(then2Reached)
            XCTAssertTrue(then3Reached)
        }
    }
    
    
    /*func task3() -> Task<Int> {
        let manager = TaskManager<Int>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(1.0)
            manager.complete(3)
        }
        
        return manager.task
    }
    
    func task4() -> Task<Double> {
        let manager = TaskManager<Double>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(1.0)
            manager.complete(4.0)
        }
        
        return manager.task
    }*/
}
