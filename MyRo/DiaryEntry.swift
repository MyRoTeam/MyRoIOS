//
//  DiaryEntry.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public final class DiaryEntry: NSObject, JSONModel {
    public var tags: [String]!
    public var date: NSDate!
    public var location: String!
    public var image: UIImage!
    
    public override init() {
        super.init()
    }
    
    public func map(jsonMap: JSONMap) {
        self.tags ~> jsonMap["tags"]
        self.date ~> (jsonMap["date"], DateCoder(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        self.location ~> jsonMap["location"]
        self.image ~> (jsonMap["image"], ImageBase64Coder())
    }
}
