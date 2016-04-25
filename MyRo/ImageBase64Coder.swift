//
//  ImageBase64Coder.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public class ImageBase64Coder: JSONCoder {
    public typealias Obj = UIImage
    public typealias JSON = String
    
    public init() {
    }
    
    public func decode(value: AnyObject?) -> Obj? {
        guard let base64String = value as? String else { return nil }
        guard let data = NSData(base64EncodedString: base64String, options: []) else { return nil }
        
        return UIImage(data: data)
    }
    
    public func encode(value: Obj?) -> JSON? {
        guard let image = value else { return nil }
        
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return nil }
        let base64String = data.base64EncodedStringWithOptions([])
        
        return base64String
    }
}
