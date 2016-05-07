//
//  Landmark.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/29/16.
//  Copyright © 2016 MyRo. All rights reserved.
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
