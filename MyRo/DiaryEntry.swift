//
//  DiaryEntry.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// Class that models each of a user's diary entries
public final class DiaryEntry: NSObject, JSONModel {
    /// Tags that describe the image
    public var tags: [String]!
    
    /// Date/time this image was saved
    public var date: NSDate!
    
    /// Location of where this image was taken
    public var location: String!
    
    /// The actual image
    public var image: UIImage!
    
    public override init() {
        super.init()
    }
    
    public func map(jsonMap: JSONMap) {
        self.tags ~> jsonMap["tags"]
        self.date ~> (jsonMap["date"], DateCoder(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        self.location ~> jsonMap["location"]
        self.image ~> (jsonMap["image"], ImageBase64Coder(compressionRate: 0.5))
    }
}
