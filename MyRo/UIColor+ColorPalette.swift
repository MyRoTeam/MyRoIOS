//
//  UIColor+ColorPalette.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
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
