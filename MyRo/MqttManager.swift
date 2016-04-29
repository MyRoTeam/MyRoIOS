//
//  MqttManager.swift
//  Wink
//
//  Created by Aadesh Patel on 3/15/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

public class MqttManager: NSObject {
    public static var sharedManager = MqttManager()
    
    public struct NotificationKey {
        public static let MQTTDidConnectNotification = "MQTTDidConnectNotification"
        public static let MQTTDidDisconnectNotification = "MQTTDidDisconnectNotification"
        public static let MQTTDidReceiveNotification = "MQTTDidReceiveNotification"
    }
    
    internal static let mqttHost = "ec2-52-90-110-163.compute-1.amazonaws.com"
    internal static let mqttPort = 1883
    internal static let mqttSSLPort = 8883
    internal static let mqttClientId = "myro-\(arc4random_uniform(1000))"
    internal static let mqttSecurityPolicy: MQTTSSLSecurityPolicy = {
        let sp = MQTTSSLSecurityPolicy()
        sp.allowInvalidCertificates = true
        
        return sp
    }()
    
    private var manager: MQTTSessionManager!
    private var subscribeToOnConnect = [String]()
    
    internal override init() {
        super.init()
        
        self.manager = MQTTSessionManager()
        self.manager.delegate = self
        
        self.manager.addObserver(self,
            forKeyPath: "state",
            options: [.Initial, .New],
            context: nil)
    }
    
    internal convenience init(subscriptions: [String]) {
        self.init()
        
        var subscriptionsDict = [String : NSNumber]()
        
        for subscription in subscriptions {
            subscriptionsDict[subscription] = NSNumber(unsignedChar: 0)
        }
        
        self.manager.subscriptions = subscriptionsDict
    }
    
    deinit {
        self.manager.removeObserver(self, forKeyPath: "state")
    }
    
    public func connect() {
        self.manager.connectTo(
            MqttManager.mqttHost,
            port: MqttManager.mqttPort,
            tls: false,
            keepalive: 60,
            clean: false,
            auth: false,
            user: nil,
            pass: nil,
            will: true,
            willTopic: "myro/will",
            willMsg: "offline".dataUsingEncoding(NSUTF8StringEncoding),
            willQos: .AtMostOnce,
            willRetainFlag: false,
            withClientId: MqttManager.mqttClientId,
            securityPolicy: MqttManager.mqttSecurityPolicy,
            certificates: nil)
        
        self.manager.connectToLast()
    }
    
    public func disconnect() {
        self.manager.disconnect()
    }
    
    public func publish(topic: String, message: String, retain: Bool = false) {
        self.manager.sendData(
            message.dataUsingEncoding(NSUTF8StringEncoding),
            topic: topic,
            qos: .AtMostOnce,
            retain: retain)
    }
    
    public func subscribe(topic: String) {
        self.manager.session.subscribeToTopic(topic, atLevel: .AtMostOnce)
    }
    
    public func isConnected() -> Bool {
        return self.manager.state == .Connected
    }
}

extension MqttManager: MQTTSessionManagerDelegate {
    public func handleMessage(data: NSData!, onTopic topic: String!, retained: Bool) {
        print("Did Receive Message")
        
        guard let message = String(data: data, encoding: NSUTF8StringEncoding) else {
            return
        }
        
        print("Did Receive Message: \(message)")
        
        NSNotificationCenter.defaultCenter().postNotificationName(MqttManager.NotificationKey.MQTTDidReceiveNotification, object: message)

        //NSNotificationCenter.defaultCenter().postNotificationName(MqttManager.NotificationKey.MQTTDidReceiveMatchNotification, object: MqttMessage(topic: topic, message: message))
    }
}

extension MqttManager {
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch(self.manager.state) {
        case .Connected:
            print("Connected")
            
            //self.subscribe("match/\(User.currentUser.id.longLongValue)")
            //self.subscribe("match_found/\(User.currentUser.id.longLongValue)")
            //self.subscribe("chat/+/\(User.currentUser.id.longLongValue)")
            
            //MqttManager.sharedManager.subscribe("match/\(User.currentUser.id.longLongValue)")
            NSNotificationCenter.defaultCenter().postNotificationName(MqttManager.NotificationKey.MQTTDidConnectNotification, object: nil)
            break
            
        case .Closed:
            print("Disconnected")
            NSNotificationCenter.defaultCenter().postNotificationName(MqttManager.NotificationKey.MQTTDidDisconnectNotification, object: nil)
            break
            
        default:
            break
        }
    }
}


public class MqttMessage {
    public var topic: String!
    public var message: String!
    
    public init(topic: String, message: String) {
        self.topic = topic
        self.message = message
    }
}