//
//  UIColor+ColorPalette.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/3/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

/// UIColor extension for MyRo color palette
extension UIColor {
    /// Convenience init for whole number RGB values
    private convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: (red / 255.0), green: (green / 255.0), blue: (blue / 255.0), alpha: 1.0)
    }
    
    public static func myro_greenColor() -> UIColor {
        return UIColor(red: 16.0, green: 157.0, blue: 88.0)
    }
}
