//
//  JSONCoder.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/11/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

/// Coder used to serialize and deserialize custom values, such as
/// enums, dates, classes, etc...
public protocol JSONCoder {
    associatedtype Obj
    associatedtype JSON
    
    /**
     Deserializes the value and attempts to convert to type Obj
     
     - parameter value: Value to convert to type Obj
     
     - returns: Value converted to type Obj or nil if the conversion failed
     */
    func decode(value: AnyObject?) -> Obj?
    
    /**
     Serializes the value from type Obj to a JSON compatible value
     
     - parameter value: Value to convert to a JSON compatible value
     
     - returns: Value converted to a JSON compatible value or nil if the conversion failed
     */
    func encode(value: Obj?) -> JSON?
}