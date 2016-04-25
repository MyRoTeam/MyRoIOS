//
//  JSONCoder.swift
//  Wink
//
//  Created by Aadesh Patel on 4/11/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

public protocol JSONCoder {
    associatedtype Obj
    associatedtype JSON
    
    func decode(value: AnyObject?) -> Obj?
    func encode(value: Obj?) -> JSON?
}