//
//  NVBTextField.swift
//  MyRo-iOS
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

/// Custom UITextField subclass
class NVBTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.addBottomBorder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.addBottomBorder()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //self.addBottomBorder()
    }
    
    /// Adds bottom border to text field
    private func addBottomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0)
        bottomBorder.backgroundColor = UIColor.blackColor().CGColor;
        self.layer.addSublayer(bottomBorder)
    }
}
