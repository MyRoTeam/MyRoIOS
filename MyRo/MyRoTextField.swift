//
//  MyRoTextField.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/3/16.
//  Copyright © 2016 MyRo. All rights reserved.
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
