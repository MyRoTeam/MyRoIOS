//
//  JSONMap.swift
//
//  Created by Aadesh Patel.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Typealias for JSON objects aka [String : AnyObject]
public typealias JSON = [String : AnyObject]

/// Enum to determine whether to serialize object to JSON or deserialize JSON to object
public enum JSONMapping {
    /// Object to JSON Serialization
    case To
    
    /// JSON to Object Deserialization
    case From
}

/// Generic class that handles serialization/deserialization of JSON
public class JSONMap {
    /// If current instance of JSONMap is serializing or deserializing
    public let mapping: JSONMapping!
    
    /// Current JSON key
    private var key: String?
    
    /// Current JSON value
    private var val: AnyObject?
    
    /// JSON value holder
    private var json = [String : AnyObject]()
    
    public init(mapping: JSONMapping, json: [String : AnyObject]) {
        self.mapping = mapping
        self.json = json
    }
    
    /**
     Generic function to receive the map's current value converted to the optional 
     generic type provided
     
     - returns: Optional generic object of the map's current value
     */
    public func value<T>() -> T? {
        return self.val as? T
    }
    
    /// - returns: Map's current JSON dictionary
    public func JSON() -> [String : AnyObject] {
        return self.json
    }
    
    /**
     Sets the key and value (retrieved from the json property) for the map
     
     - parameter key: Key to set the current map object to
     
     - returns: Self
     */
    public subscript(key: String) -> JSONMap {
        get {
            self.key = key
            self.val = self.json[key]
        
            return self
        }
    }
    
    /**
     Sets the key and value in the json property
     
     - parameter key: Unique key that maps to the provided value
     - parameter value: Value to set for the provided key
     */
    public func setValue(value: AnyObject, forKey key: String) {
        self.json[key] = value
    }
}

extension JSONMap {
    /**
     Attempts to unwrap optional value and assign to left variable, if
     optional value is not nil
     
     - parameter left: Variable to assign the value parameter to
     - parameter value: Optional value to unwrap and assign to left
     */
    public static func from<T>(inout left: T, value: T?) {
        guard let v = value else { return }
        left = v
    }
    
    /**
     Assigns optional value to optional typed left variable
     
     - parameter left: Optional typed variable to assign the optional value parameter to
     - parameter value: Optional value to assign to the optional typed left variable
     */
    public static func optionalFrom<T>(inout left: T?, value: T?) {
        guard let v = value else { return }
        left = v
    }
    
    /**
     Assigns optional value to uninitialized left variable
     
     - parameter left: Uninitialized variable to assign the optional value parameter to
     - parameter value: Optional value to assign to the uninitialized left variable
     */
    public static func optionalFrom<T>(inout left: T!, value: T?) {
        guard let v = value else { return }
        left = v
    }
    
    /**
     Adds **non-nil** left value to the map, which is associated to the map's current key
     
     - parameter left: Value to add to the map for the map's current key
     - parameter map: Current instance of JSONMap
     */
    public static func to<T>(left: T, map: JSONMap) {
        guard let k = map.key, let v = left as? AnyObject else { return }
        map.setValue(v, forKey: k)
    }
    
    /**
     Attempts to unwrap **optional** left value and adds to map if successfully unwrapped,
     which is associated to the map's current key
     
     - parameter left: Optional value to add to the map for the map's current key
     - parameter map: Current instance of JSONMap
     */
    public static func optionalTo<T>(left: T?, map: JSONMap) {
        guard let v = left else { return }
        JSONMap.to(v, map: map)
    }
}
