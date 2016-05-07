//
//  MyRoTextField.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit

class MyRoTextField: UITextField {
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //self.addBottomBorder()
    }
    
    private func addBottomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0)
        bottomBorder.backgroundColor = UIColor.myro_greenColor().CGColor
        self.layer.addSublayer(bottomBorder)
    }
}
