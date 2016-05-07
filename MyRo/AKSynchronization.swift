//
//  AsyncKit
//  AKSynchronization.swift
//
//  Copyright (c) 2016 Aadesh Patel. All rights reserved.
//
//

import UIKit

/**
 Executes the block while synchronized by the lock provided
 
 - parameter lock: Object to use as a reference for synchronization
 - parameter block: Block to execute while synchronized by the lock
 */
public func synchronized(lock: AnyObject!, @noescape block: () -> Void) {
    objc_sync_enter(lock)
    block()
    objc_sync_exit(lock)
}


/**
 Executes the block while synchronized by the lock provided and returns
 the return value of the block
 
 - parameter lock: Object to use as a reference for synchronization
 - parameter block: Block to execute while synchronized by the lock
 
 - returns: Optional return value of the block that was executed
 */
public func synchronized<T>(lock: AnyObject!, @noescape block: () -> T?) -> T? {
    objc_sync_enter(lock)
    let result: T? = block()
    objc_sync_exit(lock)
    
    return result
}