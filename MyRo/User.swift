//
//  User.swift
//  MyRo-iOS
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// Class that handles all client side interaction involving Users
public final class User: NSObject, JSONModel, NSCoding {
    /**
     Retrieves the current user object logged in on the current device from
     the keychain cache
     */
    public static var currentUser: User! {
        set {
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "current_user")
            NSUserDefaults.standardUserDefaults().synchronize()
            //KeychainWrapper.sharedKeychain().setData(NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "current_user")
        }
        get {
            guard let data = NSUserDefaults.standardUserDefaults().objectForKey("current_user") as? NSData else {
                return nil
            }
            
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
            
            /*if let data = KeychainWrapper.sharedKeychain().dataForKey("current_user") {
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
                
                return user
            }
            
            return nil*/
        }
    }
    
    /**
     Retrieves the current user's authentication token (saved on successful login),
     from the keychain cache, required to make server requests that require a logged
     in user
     
     - returns: Current user's authentication token string
     */
    public static var authToken: String! {
        set {
            //KeychainWrapper.sharedKeychain().setData(newValue.dataUsingEncoding(NSUTF8StringEncoding), forKey: "auth_token")
            NSUserDefaults.standardUserDefaults().setObject(newValue.dataUsingEncoding(NSUTF8StringEncoding), forKey: "auth_token")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            guard let data = NSUserDefaults.standardUserDefaults().objectForKey("auth_token") as? NSData else {
                return nil
            }
            
            return String(data: data, encoding: NSUTF8StringEncoding)
            /*
            if let data = KeychainWrapper.sharedKeychain().dataForKey("auth_token") {
                guard let token = String(data: data, encoding: NSUTF8StringEncoding) else { return nil }
                
                return token
            }
            
            return nil*/
        }
    }
    
    /**
     Retrieves the token required to connect to a specific robot via websocket channel, from
     the keychain cache. Received on successful server request to /users/:id/connect/.
 
     - returns: Connected robot's token string
     */
    public static var connectedRobotToken: String! {
        set {
            KeychainWrapper.sharedKeychain().setData(newValue.dataUsingEncoding(NSUTF8StringEncoding), forKey: "connected_robot_token")
        }
        get {
            if let data = KeychainWrapper.sharedKeychain().dataForKey("connected_robot_token") {
                guard let token = String(data: data, encoding: NSUTF8StringEncoding) else { return nil }
                
                return token
            }
            
            return nil
        }
    }
    
    /// The unique ID of the robot object that corresponds to the MongoDB ID
    public var id: String!
    
    /// Unique username required to login
    public var username: String!
    
    required public override init() {

    }
    
    public init(username: String) {
        self.username = username
    }
    
    public func map(jsonMap: JSONMap) {
        self.id ~> jsonMap["_id"]
        self.username ~> jsonMap["username"]
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? String
        self.username = aDecoder.decodeObjectForKey("username") as? String
    }
    
    @objc public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.username, forKey: "username")
    }
}