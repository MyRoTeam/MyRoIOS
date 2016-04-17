//
//  CloudVision.swift
//  MyRo
//
//  Created by Nikhil Nelson on 4/16/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import Foundation

enum GoogleCloudVisionRoute: APIRoute {
    case GetTags
    
     static let API_KEY = "AIzaSyDOAarYgPGxZGmWVH8B8nuSsFEhvXBN6hU"
    
    var description: String{
        switch (self)
        {
        case .GetTags:
            return "https://vision.googleapis.com/v1/images:annotate?key=\(GoogleCloudVisionRoute.API_KEY)"
        }
    }
}

class CloudVision
{
    var API_KEY = "AIzaSyDOAarYgPGxZGmWVH8B8nuSsFEhvXBN6hU"
    
    
    func createRequest(imageData: String) {
        
        let jsonRequest: [String: AnyObject] = [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        APIClient.POST(GoogleCloudVisionRoute.GetTags, params: jsonRequest, headerParams: ["X-Ios-Bundle-Identifier": NSBundle.mainBundle().bundleIdentifier!])
            .then { json in
            print(json)
        }
        
        
    }
    
    
    func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    
    func base64EncodeImage(image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.length > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
   
    func execute(image: UIImage)
    {
        let encodedImage = base64EncodeImage(image)
        createRequest(encodedImage)
    }
    
    
    
}
