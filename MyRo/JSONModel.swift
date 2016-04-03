//
//  JSONModel.swift
//
//  Created by Aadesh Patel.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Protocol to handle object JSON serialization and deserialization
public protocol JSONModel {
    init()
    
    /**
     Method that must be implemented by subclass to
     serialize/deserialize an instance of the subclass
     
     - parameter jsonMap: JSON mapping class used to map object properties to json keys
     */
    func map(jsonMap: JSONMap)
    
    /**
     Converts an instance of the subclass to JSON aka [String : AnyObject]
     
     - returns: Serialized JSON of the object
     */
    @warn_unused_result
    func toJSON() -> JSON
    
    /**
     Deserializes JSON data to create and return an instance of the subclass
     
     - returns: Instance of subclass that was created based on the JSON supplied
     */
    @warn_unused_result
    static func fromJSON(json: JSON) -> Self
}

/// Extension of the JSONModel protocol to implement the generic methods: toJSON() and fromJSON(json: JSON)
public extension JSONModel {
    @warn_unused_result
    public func toJSON() -> [String : AnyObject] {
        let map = JSONMap(mapping: .To, json: [:])
        self.map(map)
        
        return map.JSON()
    }
    
    @warn_unused_result
    public static func fromJSON(json: [String : AnyObject]) -> Self {
        let map = JSONMap(mapping: .From, json: json)
        let s = Self()
        s.map(map)
        
        return s
    }
}