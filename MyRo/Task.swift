//
//  AsyncKit
//  Task.swift
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import Foundation

/**
 Function that runs a block in a default priority background thread, and returns
 the result of the block wrapped around a Task object
 
 - parameter block: Block to execute asynchronously
 
 - returns: Task wrapper object of the result of the block
 */
public func task<T>(block: () -> T) -> Task<T> {
    let manager: TaskManager<T> = TaskManager()
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        manager.complete(block())
    }
    
    return manager.task
}

/// Wrapper class so that any data type can be treated as an object
public class TaskResultWrapper<T> {
    /// Actual data this class is wrapped around
    private var result: T!
    
    public init(result: T) {
        self.result = result
    }
}

/// Generic result of a Task object
/// - Success
/// - Failure with NSError
/// - Failure with NSException
/// - Canceled
public enum TaskResult<T> {
    /// Task completed successfully
    case Success(TaskResultWrapper<T>)
    
    /// Task failed with an error
    case FailWithError(NSError)
    
    /// Task failed with an exception
    case FailWithException(NSException)
    
    /// Task was canceled
    case Cancel
    
    public var isSuccess: Bool {
        get {
            switch(self) {
                case .Success:
                    return true
                default:
                    return false
            }
        }
    }
    
    public var isFail: Bool {
        get {
            switch(self) {
                case .FailWithError:
                    return true
                case .FailWithException:
                    return true
                default:
                    return false
            }
        }
    }
    
    public var isCancel: Bool {
        get {
            switch(self) {
            case .Cancel:
                return true
            default:
                return false
            }
        }
    }
    
    public var result: T! {
        get {
            switch(self) {
            case let .Success(r):
                return r.result
            default:
                return nil
            }
        }
    }
    
    public var error: NSError! {
        get {
            switch(self) {
            case let .FailWithError(e):
                return e
            default:
                return nil
            }
        }
    }
    
    public var exception: NSException! {
        get {
            switch(self) {
            case let .FailWithException(e):
                return e
            default:
                return nil
            }
        }
    }
}

/// Core class that handles all callbacks based on the type of completion
public class Task<T> {
    /// Result data that this Task object is holding
    private var result: TaskResult<T>!
    
    /// Queue of callbacks to be invoked
    private var callbackQueue: TaskQueue<((TaskResult<T>) -> Void)>?
    
    /// List of callbacks to be invoked
    private var callbacks: [(TaskResult<T>) -> Void]!
    //private var errorBlock: ((NSError) -> Void)!
    
    public init() {
        self.callbacks = []
    }
    
    /**
     Successfully completes this task successfully with the result provided
     
     - parameter result: Result of this task's execution
     */
    public func completeWithResult(result: TaskResult<T>) {
        self.completeWithBlock({ () -> TaskResult<T> in
            return result
        })
    }
    
    /**
     Executes the block provided, and successfully completes the task
     with the result of the block
     
     - parameter block: Block to be executed and successfully complete this
                        task with
     */
    private func completeWithBlock(block: (() -> TaskResult<T>)) {
        synchronized(self) {
            if (self.result != nil) {
                return
            }
            
            self.result = block()
            for callback in self.callbacks {
                callback(self.result)
            }            
        }
    }
    
    /**
     Executes the block provided after this task is completed successfully. If it is not
     completed successfully (completed by error or exception), then the block provided will
     **NOT** be executed
     
     - parameter executorType: Thread to execute the block in. Defaults to the main thread
     - parameter block: Block to execute after this task completes successfully
     
     - returns: Another Task object wrapped around the result of the block executed, so that
                "then" blocks can be chained
     */
    public func then<K>(executorType: ExecutorType = ExecutorType.Main, _ block: ((T) -> K)) -> Task<K> {
        let executor: Executor = Executor(type: executorType)
        
        return self.thenWithResultBlock(executor) { (t: T) -> TaskResult<K> in
            return TaskResult<K>.Success(TaskResultWrapper(result: block(t)))
        }
    }
    
    /**
     Private function that does the same as the then method, except the block returns a 
     TaskResult object
     
     - parameter executor: Provider of the type of thread to execute the block in
     - parameter block: Block to execute after this task completes successfully
     
     - returns: Another Task object wrapped around the TaskResult of the block executed
     */
    private func thenWithResultBlock<K>(executor: Executor, _ block: (T) -> TaskResult<K>) -> Task<K> {
        return self.taskForBlock(executor) { (result: TaskResult<T>) -> TaskResult<K> in
            switch(result) {
            case .Success:
                return block(result.result)
            case .FailWithError:
                return .FailWithError(result.error)
            case .FailWithException:
                return .FailWithException(result.exception)
            case .Cancel:
                return .Cancel
            }
        }
    }
    
    /**
     Executes the block provided only if this task fails with an error
     
     - parameter block: Block to be executed if this task fails with an error
     
     - returns: Another Task object to allow chaining
     */
    public func error(block: (NSError) -> Void) -> Task<T> {
        self.queueTaskCallback { (result: TaskResult<T>) -> Void in
            if (result.error != nil) {
                block(result.error)
            }
        }
        
        return self
    }
    
    /**
     Executes the block provided only if this task fails with an exception
     
     - parameter block: Block to be executed if this task fails with an exception
     
     - returns: Another Task object to allow chaining
     */
    public func error(block: (NSException) -> Void) -> Task<T> {
        self.queueTaskCallback { (result: TaskResult<T>) -> Void in
            if (result.exception != nil) {
                block(result.exception)
            }
        }
        
        return self
    }
    
    /**
     **ALWAYS** executes the block provided at the end, regardless of the 
     outcome of this task
     
     - parameter block: Block to execute no matter of the outcome of the task
     
     - returns: Another Task object to allow chaining
     */
    public func finally(block: () -> Void) -> Task<T> {
        self.queueTaskCallback { (_: TaskResult<T>) -> Void in
            block()
        }
        
        return self
    }
    
    /**
     Generates and returns a Task object for the block provided
     
     - parameter executor: Provider of the type of thread to execute the block in
     - parameter block: Block to execute if this task completes successfully
     
     - returns: Another Task object wrapped around the result of the block
     */
    private func taskForBlock<K>(executor: Executor, _ block: (TaskResult<T>) -> TaskResult<K>) -> Task<K> {
        
        let taskManager: TaskManager<K> = TaskManager<K>()
        let taskCallback: ((TaskResult<T>) -> Void) = { (result: TaskResult<T>) -> Void in
            taskManager.complete(block(result))
            
            return
        }
        
        let execBlock = executor.executionBlock(taskCallback)
        self.queueTaskCallback(execBlock)
        
        return taskManager.task
    }
    
    /**
     Enqueues the callback function to the queue of callbacks
     
     - parameter callback: Callback to queue
     */
    private func queueTaskCallback(callback: (TaskResult<T>) -> Void) {
        synchronized(self) {
            if (self.result != nil) {
                callback(self.result)
                
                return
            }
            
            self.callbacks.append(callback)
        }
    }
}

extension Task {
    /**
     Converts this instance of Task to Task<Void>
     
     - returns: Task<Void> of this instance of Task
     */
    private func toVoidTask() -> Task<Void> {
        return self.then { _ -> Void in }
    }
}

/// Static functions to use with Tasks
extension Task {
    /**
     Executes multiple tasks simultaneously and returns void Task object
     that only becomes available when all input tasks are completed
     
     - parameter tasks: Tasks to complete simultaneously
     
     - returns: Void Task object that becomes available only when all input tasks
                have been completed
     */
    public static func join(tasks: Task...) -> Task<Void> {
        let manager = TaskManager<Void>()
        
        guard tasks.count > 0 else {
            manager.complete()
            return manager.task
        }
        
        let numTasks = Atomic<Int>(tasks.count)
        let numErrors = Atomic<Int>(0)

        tasks.forEach { task in
            task.then(.Current) { (Void) -> Void in
            }.error { (error: NSError) in
                numErrors.value += 1
            }.finally {
                numTasks.value -= 1
                guard numTasks.value == 0 else { return }
                
                if (numErrors.value > 0) {
                    manager.completeWithError(NSError(domain: "Task Error", code: 0, userInfo: nil))
                } else {
                    manager.complete()
                }
            }
        }
        
        return manager.task
    }
    /*
    private static func join<U>(tasks: [Task<U>]) -> Task<Void> {
        return self.join(tasks)
    }
    
    public static func join<U, V>(taskT: Task<U>, _ taskK: Task<V>) -> Task<(U, V)> {
        let manager = TaskManager<(U, V)>()
        
        Task.join([taskT.toVoidTask(), taskK.toVoidTask()]).then {
            manager.complete((taskT.result.result, taskK.result.result))
        }
        
        return manager.task
    }
    
    public static func join<U, V, W>(taskT: Task<U>, _ taskK: Task<V>, _ taskU: Task<W>) -> Task<(U, V, W)> {
        let manager = TaskManager<(U, V, W)>()
        
        Task.join([taskT.toVoidTask(), taskK.toVoidTask(), taskU.toVoidTask()]).then {
            manager.complete((taskT.result.result, taskK.result.result, taskU.result.result))
        }
        
        return manager.task
    }*/
}