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

/**
 Inserts/retrieves **optional** enum into/from instance of JSONMap
 
 - parameter left: Enum value to serialize into JSONMap instance or
 deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T: RawRepresentable>(inout left: T?, right: JSONMap) {
    left ~> (right, EnumCoder())
}

/**
 Inserts/retrieves **optional** enum into/from instance of JSONMap
 
 - parameter left: Enum value to serialize into JSONMap instance or
 deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T: RawRepresentable>(inout left: T!, right: JSONMap) {
    left ~> (right, EnumCoder())
}

/**
 Inserts/retrieves **non-nil** enum into/from instance of JSONMap
 
 - parameter left: Enum value to serialize into JSONMap instance or
 deserialize from JSONMap instance
 - parameter right: Current JSONMap instance
 */
public func ~> <T: RawRepresentable>(inout left: T, right: JSONMap) {
    left ~> (right, EnumCoder())
}

/**
 Inserts/retrieves **optional** data into/front instance of JSONMap, based
 on the JSONCoder subclass provided which should be used for special types
 of data such as enums, dates, etc...
 
 - parameter left: Value to serialize into JSONMap instance or deserialize
 from JSONMap instance
 - parameter right: Tuple comprised of a JSONMap instance and a JSONCoder
 subclass instance
 */
public func ~> <T: JSONCoder>(inout left: T.Obj?, right: (JSONMap, T)) {
    let coder = right.1
    
    if (right.0.mapping == JSONMapping.From) {
        let value = coder.decode(right.0.value())
        JSONMap.optionalFrom(&left, value: value)
        return
    }
    
    let value = coder.encode(left)
    JSONMap.optionalTo(value, map: right.0)
}

/**
 Inserts/retrieves **optional** data into/front instance of JSONMap, based
 on the JSONCoder subclass provided which should be used for special types
 of data such as enums, dates, etc...
 
 - parameter left: Value to serialize into JSONMap instance or deserialize
 from JSONMap instance
 - parameter right: Tuple comprised of a JSONMap instance and a JSONCoder
 subclass instance
 */
public func ~> <T: JSONCoder>(inout left: T.Obj!, right: (JSONMap, T)) {
    let coder = right.1
    
    if (right.0.mapping == JSONMapping.From) {
        let value = coder.decode(right.0.value())
        JSONMap.optionalFrom(&left, value: value)
        return
    }
    
    let value = coder.encode(left)
    JSONMap.optionalTo(value, map: right.0)
}

/**
 Inserts/retrieves **non-nil** data into/front instance of JSONMap, based
 on the JSONCoder subclass provided which should be used for special types
 of data such as enums, dates, etc...
 
 - parameter left: Value to serialize into JSONMap instance or deserialize
 from JSONMap instance
 - parameter right: Tuple comprised of a JSONMap instance and a JSONCoder
 subclass instance
 */
public func ~> <T: JSONCoder>(inout left: T.Obj, right: (JSONMap, T)) {
    let coder = right.1
    
    if (right.0.mapping == JSONMapping.From) {
        let value = coder.decode(right.0.value())
        JSONMap.from(&left, value: value)
        return
    }
    
    let value = coder.encode(left)
    JSONMap.optionalTo(value, map: right.0)
}