//
//  UIImage+Encode.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

extension UIImage {
    public var base64EncodeString: String! {
        guard let data = UIImageJPEGRepresentation(self, 0.5) else { return nil }
        let base64 = data.base64EncodedStringWithOptions([])
        
        return base64
    }
}