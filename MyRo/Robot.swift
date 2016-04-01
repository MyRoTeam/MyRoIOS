//
//  Robot.swift
//  NeverGoneBot-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

public final class Robot: NSObject, JSONModel, NSCoding {
    public static var currentRobot: Robot! {
        set {
            //KeychainWrapper.sharedKeychain().setData(NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "current_robot")
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "current_robot")
            //NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "current_robot")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            guard let data = NSUserDefaults.standardUserDefaults().objectForKey("current_robot") as? NSData else {
                return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Robot
            
            /*
            if let data = KeychainWrapper.sharedKeychain().dataForKey("current_robot") {
                let robot = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Robot
                
                return robot
            }
            
            return nil*/
        }
    }
    
    public var id: String!
    public var name: String!
    public var udid: String!
    public var code: String!
    
    required public override init() {
        super.init()
    }
    
    public init(name: String, udid: String) {
        super.init()
        
        self.name = name
        self.udid = udid
    }
    
    public func map(jsonMap: JSONMap) {
        self.id ~> jsonMap["_id"]
        self.name ~> jsonMap["name"]
        self.udid ~> jsonMap["udid"]
        self.code ~> jsonMap["code"]
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? String
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.udid = aDecoder.decodeObjectForKey("udid") as? String
        self.code = aDecoder.decodeObjectForKey("code") as? String
    }
    
    @objc public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.udid, forKey: "udid")
        aCoder.encodeObject(self.code, forKey: "code")
    }
}
