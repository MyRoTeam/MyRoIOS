//
//  CloudVisionTag.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public final class CloudVisionTag: NSObject, JSONModel {
    internal static let scoreThreshold = 0.6
    
    public var desc: String!
    public var mid: String!
    public var score: Double!
    
    public override init() {
        super.init()
    }
    
    public func map(jsonMap: JSONMap) {
        self.desc ~> jsonMap["description"]
        self.mid ~> jsonMap["mid"]
        self.score ~> jsonMap["score"]
    }
}
