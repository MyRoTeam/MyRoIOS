//
//  CloudVisionService.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

/// Handles API routes for Google Vision API
public enum CloudVisionRoute: APIRoute {
    private static let baseUrl = "https://vision.googleapis.com/v1/"
    
    case GetTags
    
    public var description: String {
        var route = CloudVisionRoute.baseUrl
        
        switch(self) {
        case .GetTags:
            route += "images:annotate?key=\(CloudVisionService.apiKey)"
        }
        
        return route
    }
}

/// Wrapper service of Google Vision API
public class CloudVisionService: NSObject {
    internal static let apiKey = "AIzaSyBw0yRa0ioJHJzz69Bv6INifZTo1kl_ut8"
    
    /**
     Retrieves the tags from the Google Vision API for the image provided
     
     - parameter image: Image to retrieve tags for
     
     - returns: Task wrapper of the JSON result of the API request
     */
    public static func getTags(forImage image: UIImage) -> Task<JSON> {
        guard let base64String = image.base64EncodeString else { return Task<JSON>() }
        
        let params: [String : AnyObject] = [
            "requests": [
                "image": [
                    "content": base64String
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        return APIClient.POST(CloudVisionRoute.GetTags, params: params, headerParams: ["X-Ios-Bundle-Identifier": NSBundle.mainBundle().bundleIdentifier ?? ""])
    }
}
