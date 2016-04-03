//
//  JSONModelOperator.swift
//
//  Created by Aadesh Patel.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Custom operator for use with JSONMap only
infix operator ~> {}

/**
 Inserts/retrieves **non-nil** data into/from an instance of JSONMap
 
 - parameter left: Value to serialize into JSONMap instance or deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T>(inout left: T, right: JSONMap) {
    if (right.mapping == JSONMapping.From) {
        JSONMap.from(&left, value: right.value())
        return
    }
    
    JSONMap.to(left, map: right)
}

/**
 Inserts/retrieves **optional** data into/from an instance of JSONMap
 
 - parameter left: Value to serialize into JSONMap instance or deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T>(inout left: T?, right: JSONMap) {
    if (right.mapping == JSONMapping.From) {
        JSONMap.optionalFrom(&left, value: right.value())
        return
    }
    
    JSONMap.optionalTo(left, map: right)
}

/**
 Inserts/retrieves **optional** data into/from an instance of JSONMap
 
 - parameter left: Value to serialize into JSONMap instance or deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T>(inout left: T!, right: JSONMap) {
    if (right.mapping == JSONMapping.From) {
        JSONMap.optionalFrom(&left, value: right.value())
        return
    }
    
    JSONMap.optionalTo(left, map: right)
}