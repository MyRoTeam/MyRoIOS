//
//  EasyDateInternal.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

internal struct EasyDateShared {
    internal static let sharedDateFormatter = {
        return NSDateFormatter()
    }()
}
