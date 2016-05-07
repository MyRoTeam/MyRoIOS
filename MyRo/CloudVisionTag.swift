//
//  CloudVisionTag.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// Model used to deserialize JSON data retrieved from Google Vision API
public final class CloudVisionTag: NSObject, JSONModel {
    /// Minimum confidence threshold required for the tag to be displayed to the user
    internal static let scoreThreshold = 0.6
    
    /// Actual tag name
    public var desc: String!

    public var mid: String!
    
    /// How confident the AI is that the tag describes the image (0.0 to 1.0)
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
