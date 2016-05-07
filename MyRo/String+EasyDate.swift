//
//  String+EasyDate.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

extension String {
    /// Attempts to convert this string to a NSDate object based on
    /// the format provided
    public func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> NSDate? {
        return EasyDate(string: self, format: format)?.date
    }
}
