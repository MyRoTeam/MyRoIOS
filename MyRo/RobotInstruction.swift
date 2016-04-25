//
//  RobotInstruction.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/25/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public final class RobotInstruction: NSObject, JSONModel {
    /// Speed represented as a decimal between 0.0 and 1.0
    /// - 0.0 - No movement
    /// - 1.0 - Max speed
    public var speed: CGFloat!
    
    /// Angle represented as radians from -PI to PI
    /// - 0.0 - Move Right
    /// - PI/2 - Move Forward
    /// - PI - Move Left
    /// - -PI/2 - Move Backwards
    public var angle: CGFloat!
    
    public override init() {
        super.init()
    }
    
    public init(speed: CGFloat, angle: CGFloat) {
        super.init()
        
        self.speed = speed
        self.angle = angle
    }
    
    public func map(jsonMap: JSONMap) {
        self.speed ~> jsonMap["speed"]
        self.angle ~> jsonMap["angle"]
    }
}
