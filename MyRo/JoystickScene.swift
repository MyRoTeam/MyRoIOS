//
//  JoystickScene.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import SpriteKit

@objc public protocol JoystickDelegate {
    /// Protocol method invoked when movement is detected on joystick
    func joystickDidMove(joystickView: JoystickView)
}

public class JoystickScene: SKScene {
    public weak var joystickDelegate: JoystickDelegate?
    
    /// Joystick View
    private var joystickView: JoystickView!
    
    public override init(size: CGSize) {
        super.init(size: size)
        
        self.baseInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.baseInit()
    }
    
    private func baseInit() {
        self.joystickView = JoystickView()
        self.joystickView.position = CGPointMake(50.0, 50.0)
        self.addChild(self.joystickView)
        self.backgroundColor = UIColor.clearColor()
    }
    
    /// Invokes the joystick protocol to notify current delegate that
    /// the joystick has moved
    public override func update(currentTime: NSTimeInterval) {
        if (self.joystickView.changed) {
            print("UPDATING")
            self.joystickDelegate?.joystickDidMove(self.joystickView)
            self.joystickView.changed = false
        }
    }
}
