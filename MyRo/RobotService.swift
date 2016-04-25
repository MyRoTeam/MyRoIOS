//
//  RobotService.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 3/18/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Enum that handles server API request routes related to robots
public enum RobotServiceRoute: APIRoute {
    /// Base sub route of the robot API service
    private static let baseRoute = "\(APIClient.BaseUrl)/robots/"
    
    /// Route to create a new robot
    case Create
    
    /// Route to retrieve a specific existing robot based on the supplied ID
    case Get(String)
    
    /// - returns: Full string of the robot API request route
    public var description: String {
        get {
            var route = RobotServiceRoute.baseRoute
            
            switch(self) {
            case .Get(let id):
                route += "\(id)/"
            default:
                route += ""
            }
            
            return route
        }
    }
}

/// Service class that handles server API requests related to robots
public class RobotService: NSObject {
    /// Block that converts Robot JSON to Robot object
    private static let jsonToRobotBlock = { (json: JSON) -> Robot in
        return Robot.fromJSON(json)
    }

    /**
    Sends a request to the server to create a new robot object
    
     - parameter robot: Robot object that needs to be saved in the server database
     
     - returns: Task containing Robot object created
     
     **/
    public static func createRobot(robot: Robot) -> Task<Robot> {
        return APIClient.POST(
            RobotServiceRoute.Create,
            params: robot.toJSON()
        ).then(.Current, self.jsonToRobotBlock)
    }
    
    /**
     Retrieves the specific robot object from the server, based on the unique MongoDB ID supplied
 
     - parameter robotId: Unique robot ID whose robot object needs to be retrieved
     
     - returns: Task containing Robot object retrieved
     */
    public static func getRobot(robotId: String) -> Task<Robot> {
        return APIClient.GET(
            RobotServiceRoute.Get(robotId),
            params: nil
        ).then(.Current, self.jsonToRobotBlock)
    }
}
