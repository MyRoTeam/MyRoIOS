//
//  DateCoder.swift
//  Wink
//
//  Created by Aadesh Patel on 4/11/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

public class DateCoder: JSONCoder {
    public typealias Obj = NSDate
    public typealias JSON = String
    
    private let format: String!
    
    public init(format: String) {
        self.format = format
    }
    
    public func decode(value: AnyObject?) -> NSDate? {
        guard let dateString = value as? String else {
            return nil
        }
        
        return dateString.toDate(self.format)
    }
    
    public func encode(value: NSDate?) -> String? {
        guard let date = value else {
             return nil
        }
        
        return date.dateString()
    }
}
