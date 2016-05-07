//
//  DateCoder.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// JSONCoder subclass for NSDate
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
        
        return date.dateString(self.format)
    }
}
