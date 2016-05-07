//
//  JoystickView.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import SpriteKit

public enum JoystickDirection: RawRepresentable {
    case Forward
    case Backward
    case Left
    case Right
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch(self) {
        case .Forward:
            return "F"
        case .Backward:
            return "B"
        case .Left:
            return "L"
        case .Right:
            return "R"
        }
    }
    
    public init(angle: Double) {
        if ((angle >= 0.0 && angle <= M_PI_4) || (angle >= -M_PI_4 && angle <= 0.0)) {
            self = .Right
        } else if (angle > M_PI_4 && angle <= (3 * M_PI_4)) {
            self = .Forward
        } else if ((angle > (3 * M_PI_4) && angle <= M_PI) || (angle >= -M_PI && angle <= -(3 * M_PI_4))) {
            self = .Left
        } else if (angle > -(3 * M_PI_4) && angle < -M_PI_4) {
            self = .Backward
        } else {
            self = .Forward
        }
    }
    
    public init?(rawValue: RawValue) {
        switch(rawValue) {
        case "B":
            self = .Backward
        case "L":
            self = .Left
        case "R":
            self = .Right
        default:
            self = .Forward
        }
    }
}

public class JoystickView: SKShapeNode {
    /// If there were any recent movements on the joystick view
    public var changed: Bool = false
    
    /// Percentage of distance moved from the joystick's original position,
    /// (0.0 to 1.0) 1.0 being when it hits the outer edge
    private(set) public var hyp: CGFloat = 0.0
    
    /// Direction of the joystick: F, L, R, B
    private(set) public var direction: JoystickDirection!
    
    /// Percentage of distance moved horizontally
    private(set) public var x: CGFloat!
    
    /// Percentage of distance moved vertically
    private(set) public var y: CGFloat!
    
    /// Angle at which the joystick is currently at: 0 to PI or -PI to 0
    private(set) public var angle: CGFloat!
    
    private var node: SKShapeNode!
    private var touch: UITouch!
    
    private var maxDistance: CGFloat = 35.0
    
    private var baseRadius: CGFloat = 40.0
    private var baseColor: UIColor = UIColor.lightGrayColor()
    
    private var joystickRadius: CGFloat = 15.0
    private var joystickColor: UIColor = UIColor.grayColor()
    
    public override init() {
        super.init()
        
        self.baseInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.baseInit()
    }
    
    private func baseInit() {
        self.userInteractionEnabled = true
        
        let baseDiameter = self.baseRadius * 2.0
        var circlePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(circlePath, nil, CGRectMake(self.position.x - self.baseRadius, self.position.y - self.baseRadius, baseDiameter, baseDiameter))
        self.path = circlePath
        self.fillColor = self.baseColor
        self.lineWidth = 0.0
        
        let joystickDiameter = self.joystickRadius * 2.0
        self.node = SKShapeNode()
        circlePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(circlePath, nil, CGRectMake(self.position.x - self.joystickRadius, self.position.y - self.joystickRadius, joystickDiameter, joystickDiameter))
        self.node.path = circlePath
        self.node.fillColor = self.joystickColor
        self.node.lineWidth = 0.0
        self.node.position = self.position
        self.node.zPosition = 1.0
        self.addChild(self.node)
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        guard self.touch == nil else { return }
        self.touch = touches.first
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        guard self.touch != nil else { return }
        
        let point = self.touch.locationInNode(self.parent!)
        
        var x = point.x
        var y = point.y
        
        if ((pow(x - self.position.x, 2) + pow(y - self.position.y, 2)) > pow(self.maxDistance, 2)) {
            //self.angle = CGFloat(atan2f(Float(y - self.position.y), Float(x - self.position.x)))
            x = self.position.x + self.maxDistance * cos(self.angle)
            y = self.position.y + self.maxDistance * sin(self.angle)
            //self.direction = JoystickDirection(angle: Double(self.angle))
        }
        
        self.angle = CGFloat(atan2f(Float(y - self.position.y), Float(x - self.position.x)))
        let newDirection = JoystickDirection(angle: Double(self.angle))
        
        self.node.position = self.convertPoint(CGPointMake(x, y), fromNode: self.parent!)
        self.x = (x - self.position.x) / self.maxDistance
        self.y = (y - self.position.y) / self.maxDistance
        let newHyp = sqrt(pow(self.x, 2) + pow(self.y, 2))
        
        self.changed = self.direction != newDirection
        self.direction = newDirection
        self.hyp = newHyp
        //self.changed = true
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        guard touches.contains(self.touch) else { return }
        self.reset()
        self.changed = true
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        guard ((touches?.contains(self.touch)) != nil) else { return }
        self.reset()
        self.changed = true
    }
    
    /// Reset all movement settings for joystick. Occurs when 
    /// user lets go of the joystick
    private func reset() {
        self.touch = nil
        self.x = 0.0
        self.y = 0.0
        self.hyp = 0.0
        self.direction = .Forward
        self.node.position = CGPointMake(0.0, 0.0)
    }
}
