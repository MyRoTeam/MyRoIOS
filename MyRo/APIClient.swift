//  Created by Aadesh Patel
//  Copyright © 2015 Aadesh Patel. All rights reserved.
//

import UIKit

/// Interface for API route management classes
public protocol APIRoute {
    
    /// - returns: Full string of the API request route
    var description: String { get }
}

/// Data type for parameters to be sent with an API request
public typealias APIParameters = [String : AnyObject]?

/// Success block type on API request success
public typealias APISuccessBlock = (([String : AnyObject]) -> Void)?

/// Failure block type on API request failure
public typealias APIFailureBlock = ((NSError) -> Void)?

/// Wrapper class that uses the AFNetworking library to send API requests
public class APIClient: NSObject {
    /**
     Static http request manager used throughout the lifetime of the application
     
     - returns: AFHTTPRequestOperationManager object that only accepts and sends JSON typed objects
     */
    private static var HttpReqManager: AFHTTPRequestOperationManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static let httpReqManager = AFHTTPRequestOperationManager()
        }
        
        dispatch_once(&Static.onceToken) {
            Static.httpReqManager.requestSerializer = AFJSONRequestSerializer()
            Static.httpReqManager.responseSerializer = AFJSONResponseSerializer()
            Static.httpReqManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            Static.httpReqManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return Static.httpReqManager
    }
    
    /// Base URL of the API Server
    private static let BaseUrl = "https://pure-fortress-98966.herokuapp.com/"
    
    /**
     Sends GET API request to the server
     
     - parameter route: API route to send the request to
     - parameter params: Parameters to send with the request
     - parameter success: Callback that gets invoked if the request is successful
     - parameter failure: Callback that gets invoked if the request fails
     */
    public static func GET(route: APIRoute, params: APIParameters, success: APISuccessBlock, failure: APIFailureBlock)
    {
        APIClient.HttpReqManager.GET(APIClient.BaseUrl + route.description,
            parameters: params as? AnyObject,
            success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                guard let dict = response as? [String : AnyObject] else {
                    return
                }
                
                success?(dict)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                failure?(error)
        })
    }
    
    /**
     Sends POST API request to the server
     
     - parameter route: API route to send the request to
     - parameter params: Parameters to send with the request
     - parameter success: Callback that gets invoked if the request is successful
     - parameter failure: Callback that gets invoked if the request fails
     */
    public static func POST(route: APIRoute, params: APIParameters, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.HttpReqManager.POST(APIClient.BaseUrl + route.description,
            parameters: params!,
            success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                guard let dict = response as? [String : AnyObject] else {
                    return
                }
                
                success?(dict)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                failure?(error)
        })
    }
    
    /**
     Sends POST request to the server with the specific HTTP headers supplied
     
     - parameter route: API route to send the request to
     - parameter params: Parameters to send with the request
     - parameter headerParams: HTTP Header fields to add to the request serializer
     - parameter success: Callback that gets invoked if the request is successful
     - parameter failure: Callback that gets invoked if the request fails
     */
    public static func POST(route: APIRoute, params: APIParameters, headerParams: [String : String]?, success: APISuccessBlock, failure: APIFailureBlock) {
        let prevRequestSerializer = APIClient.HttpReqManager.requestSerializer
        
        if let header = headerParams {
            guard let requestSerializer = APIClient.HttpReqManager.requestSerializer.mutableCopy() as? AFHTTPRequestSerializer else { return }
            for (k, v) in header {
                requestSerializer.setValue(v, forHTTPHeaderField: k)
            }
            
            APIClient.HttpReqManager.requestSerializer = requestSerializer
        }
        
        APIClient.HttpReqManager.POST(APIClient.BaseUrl + route.description,
                                      parameters: params!,
                                      success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                                        guard let dict = response as? [String : AnyObject] else {
                                            return
                                        }
                                        
                                        success?(dict)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                failure?(error)
        })
        
        APIClient.HttpReqManager.requestSerializer = prevRequestSerializer
    }
    
    /**
     Sends PUT request to the server
     
     - parameter route: API route to send the request to
     - parameter params: Parameters to send with the request
     - parameter success: Callback that gets invoked if the request is successful
     - parameter failure: Callback that gets invoked if the request fails
     */
    public static func PUT(route: APIRoute, params: APIParameters, success: APISuccessBlock, failure: APIFailureBlock) {
        APIClient.HttpReqManager.PUT(APIClient.BaseUrl + route.description,
            parameters: params!,
            success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                guard let dict = response as? [String : AnyObject] else {
                    return
                }
                
                success?(dict)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                failure?(error)
        })
    }
}
