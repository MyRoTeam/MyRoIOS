//
//  EasyDateInternal.swift
//  Wink
//
//  Created by Aadesh Patel on 3/20/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

internal struct EasyDateShared {
    internal static let sharedDateFormatter = {
        return NSDateFormatter()
    }()
}
