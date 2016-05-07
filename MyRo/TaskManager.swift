
//
//  AsyncKit
//  TaskManager.swift
//
//  Copyright (c) 2016 Aadesh Patel. All rights reserved.
//
//

import Foundation

/// Manager class that handles all interactions with it's underlying task
public class TaskManager<T> {
    private(set) public var task: Task<T>
    
    public init() {
        self.task = Task()
    }
    
    /**
     Successfully completes the task with the result provided
     
     - parameter result: Result to complete the task with
     */
    public func complete(result: T) {
        synchronized(self) {
            self.task.completeWithResult(.Success(TaskResultWrapper(result: result)))
        }
    }
    
    /**
     Successfully completes the task with the TaskResult provided
     
     - parameter result: TaskResult to complete the task with
     */
    public func complete(result: TaskResult<T>) {
        synchronized(self) {
            self.task.completeWithResult(result)
        }
    }
    
    /**
     Ends the task with a failure, caused by the error provided
     
     - parameter error: NSError that caused the task to fail
     */
    public func completeWithError(error: NSError) {
        synchronized(self) {
            self.task.completeWithResult(.FailWithError(error))
        }
    }
    
    /**
     Ends the task with a failure, caused by the exception provided
     
     - parameter exception: NSException that caused the task to fail
     */
    public func completeWithException(exception: NSException) {
        synchronized(self) {
            self.task.completeWithResult(.FailWithException(exception))
        }
    }
    
    /// Stops the task from completing
    public func cancel() {
        synchronized(self) {
            self.task.completeWithResult(.Cancel)
        }
    }
}
