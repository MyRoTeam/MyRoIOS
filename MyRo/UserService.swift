//
//  UserService.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 2/3/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Enum that handles server API request routes related to users
public enum UserServiceRoute: APIRoute {
    /// Base sub route of the user API service
    private static let baseRoute = "users/"
    
    /// Route to create a new user
    case Create
    
    /// Route to update an existing user with the supplied ID
    case Update(String)
    
    /// Route to authenticate a user
    case Authenticate
    
    /// Route to retrieve a specific existing user with the supplied ID
    case Get(String)
    
    /// Route to initialize a connection to a specific robot for a user with the supplied ID
    case Connect(String)
    
    /// - returns: Full string of the user API request route
    public var description: String {
        get {
            var route = UserServiceRoute.baseRoute
            
            switch(self) {
            case .Get(let userId):
                route += "\(userId)/"
                break
                
            case .Update(let userId):
                route += "\(userId)/"
                break
                
            case .Authenticate:
                route += "login/"
                break
                
            case .Connect(let userId):
                route += "\(userId)/connect/"
                break
                
            default:
                route += ""
            }
            
            return route
        }
    }
}

/// Service class that handles server API requests related to robots
public class UserService: NSObject {
    /**
     Sends a request to the server to create a new user object
     
     - parameter user: User object that needs to be saved in the server database
     - parameter password: Password associated with that user object
     - parameter success: Callback that gets invoked if the server successfully saves
                          the user object in the database
     - parameter failure: Callback that gets invoked if the server request fails
     */
    public static func createUser(user: User, withPassword password: String, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.POST(UserServiceRoute.Create,
            params: ["username": user.username, "password": password],
            success: success,
            failure: failure)
    }
    
    /**
     Sends a request to the server to update an existing user object
     
     - parameter user: User object that needs to be updated in the database
     */
    public static func updateUser(user: User) {
        APIClient.PUT(UserServiceRoute.Update(user.id),
            params: ["username": user.username],
            success: nil,
            failure: nil)
    }
    
    /**
     Attempts to authenticate a user based on the credentials supplied
     
     - parameter username: User object's username
     - parameter password: User object's password
     - parameter success: Callback that gets invoked if the credentials are successfully authenticated
     - parameter failure: Callback that gets invoked if the username is invalid or password is incorrect
     */
    public static func authenticateUser(username: String!, password: String!, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.POST(UserServiceRoute.Authenticate,
            params: ["username": username, "password": password],
            success: success,
            failure: failure)
    }

    /**
     Retrieves the specific user object from the server, based on the unique MongoDB ID supplied
     
     - parameter userId: Unique user ID whose robot object needs to be retrieved
     - parameter success: Callback that gets invoked if a user object with the supplied userId exists
     - parameter failure: Callback that gets invoked if there is no user object with the supplied userId
     */
    public static func getUser(userId: String, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.GET(UserServiceRoute.Get(userId),
            params: nil,
            success: success,
            failure: failure)
    }
    
    /**
     Attempts to connect current user to robot based on the provided alphanumeric code
     
     - parameter code: Alphanumeric code for a specific robot
     - parameter success: Callback that gets invoked if user successfully connected to robot
     - parameter failure: Callback that gets invoked if user failed to connect to robot 
     */
    public static func connectToRobot(code: String, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.POST(UserServiceRoute.Connect(User.currentUser.id),
                       params: ["code": code],
                       success: success,
                       failure: failure)
    }
}
