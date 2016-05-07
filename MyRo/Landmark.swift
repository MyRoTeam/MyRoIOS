//
//  Landmark.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// Model used to deserialize JSON data retrieved from Google Places API
public final class Landmark: NSObject, JSONModel {
    /// Name of the landmark
    public var name: String!
    
    /// Latitude location of the landmark
    public var lat: Double!
    
    /// Longitude location of the landmark
    public var lon: Double!
    
    public override init() {
        super.init()
    }
    
    public func map(jsonMap: JSONMap) {
        self.name ~> jsonMap["name"]
        self.lat ~> jsonMap["geometry"]["location"]["lat"]
        self.lon ~> jsonMap["geometry"]["location"]["lng"]
    }
}
