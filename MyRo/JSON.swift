//
//  JSON.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
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
