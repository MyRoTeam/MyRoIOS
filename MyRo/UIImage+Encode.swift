//
//  UIImage+Encode.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

extension UIImage {
    /// Converts this image into a base64 string encoding, so that it can be
    /// saved in a database
    public var base64EncodeString: String! {
        guard let data = UIImageJPEGRepresentation(self, 0.5) else { return nil }
        let base64 = data.base64EncodedStringWithOptions([])
        
        return base64
    }
}