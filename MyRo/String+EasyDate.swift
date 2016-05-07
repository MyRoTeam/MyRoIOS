//
//  String+EasyDate.swift
//  MyRo
//
//  Created by Aadesh Patel on 3/20/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

extension String {
    /// Attempts to convert this string to a NSDate object based on
    /// the format provided
    public func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> NSDate? {
        return EasyDate(string: self, format: format)?.date
    }
}
