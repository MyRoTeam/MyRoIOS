//
//  Robot.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Class that handles all client-side interactions that involve Robots
public final class Robot: NSObject, JSONModel, NSCoding {
    /**
    Retrieves the current device's robot object from the keychain cache that
    was created on the handleRobotUdidIfNeeded() call in RobotViewController
     
    - Returns: Robot object that corresponds to the current device. If it hasn't
               been created, it will return nil.
    */
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
    
    /// The unique ID of the robot object that corresponds to the MongoDB ID
    public var id: String!
    
    /// The display name of the robot
    public var name: String!
    
    /// UDID of the robot, which is also the UDID of the current device
    public var udid: String!
    
    /// Six digit code required to connect to this robot
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
