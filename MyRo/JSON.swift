//
//  JSON.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public class JSONObject: NSObject {
    private var key: String?
    private var val: AnyObject?
    private var dict: [String : AnyObject]!
    
    public init(dict: [String : AnyObject]) {
        super.init()
        
        self.dict = dict
    }
    
    public subscript(key: String) -> JSONObject {
        get {
            self.key = key
            self.val = self.dict[key]
            
            return self
        }
    }
    
}
