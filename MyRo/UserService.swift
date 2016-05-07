//
//  UserService.swift
//  MyRo
//
//  Written by: Aadesh Patel and Nikhil Nelson
//  Tested by: Aadesh Patel and Nikhil Nelson
//

import UIKit

/// Enum that handles server API request routes related to users
public enum UserServiceRoute: APIRoute {
    /// Base sub route of the user API service
    private static let baseRoute = "\(APIClient.BaseUrl)/users/"
    
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
    /// Block that converts User JSON to User object
    private static let jsonToUserBlock = { (json: JSON) -> User in
        return User.fromJSON(json)
    }
    
    /**
     Sends a request to the server to create a new user object
     
     - parameter user: User object that needs to be saved in the server database
     - parameter password: Password associated with that user object
     
     - returns: Task containing User object created
     */
    public static func createUser(user: User, withPassword password: String) -> Task<User> {
        return APIClient.POST(
            UserServiceRoute.Create,
            params: ["username": user.username, "password": password]
        ).then(.Current, self.jsonToUserBlock)
    }
    
    
    
    /**
     Sends a request to the server to update an existing user object
     
     - parameter user: User object that needs to be updated in the database
     
     - returns: Task containing User object updated
     */
    public static func updateUser(user: User) -> Task<User> {
        return APIClient.PUT(
            UserServiceRoute.Update(user.id),
            params: ["username": user.username]
        ).then(.Current, self.jsonToUserBlock)
    }
    
    /**
     Attempts to authenticate a user based on the credentials supplied
     
     - parameter username: User object's username
     - parameter password: User object's password
     
     - returns: Task containing User object authenticated
     */
    public static func authenticateUser(username: String, password: String) -> Task<User> {
        return APIClient.POST(
            UserServiceRoute.Authenticate,
            params: ["username": username, "password": password]
        ).then(.Current, self.jsonToUserBlock)
    }

    /**
     Retrieves the specific user object from the server, based on the unique MongoDB ID supplied
     
     - parameter userId: Unique user ID whose robot object needs to be retrieved
     
     - returns: Task containing User object retrieved
     */
    public static func getUser(userId: String) -> Task<User> {
        return APIClient.GET(
            UserServiceRoute.Get(userId),
            params: nil
        ).then(.Current, self.jsonToUserBlock)
    }
    
    /**
     Attempts to connect current user to robot based on the provided alphanumeric code
     
     - parameter code: Alphanumeric code for a specific robot
     
     - returns: Task containing robot's authentication token
     */
    public static func connectToRobot(code: String) -> Task<String?> {
        return APIClient.POST(
            UserServiceRoute.Connect(User.currentUser.id),
            params: ["code": code]
        ).then(.Current) { json -> String? in
            return json["robotToken"] as? String
        }
    }
}
