//
//  SocketService.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 2/3/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// Callback block type for handling received messages on a specific channel
public typealias SubscriptionHandler = ([AnyObject], SocketAckEmitter) -> Void

/// Wrapper class that uses Socket.IO for websocket communication
public class SocketService: NSObject {
    /// Base server URL for the websocket server
    internal static let URL = "http://pure-fortress-98966.herokuapp.com"
    
    /**
     Static websocket client object used throughout the lifetime of the application
     
     - returns: SocketIOClient object
     */
    internal static let Socket: SocketIOClient = {
        let s = SocketIOClient(socketURL: NSURL(string: SocketService.URL)!, options: [.Log(true), .ForcePolling(true)])
        
        return s
    }()
    
    /// Connects to the websocket
    public static func connect() {
        SocketService.Socket.connect()
    }
    
    /// Subscribes to a channel on the websocket server
    public static func subscribe(topic: String, callback: SubscriptionHandler) {
        SocketService.Socket.on(topic, callback: callback)
    }
    
    /// Sends message(s) to a specific channel on the websocket server
    public static func publish(topic: String, items: AnyObject...) {
        SocketService.Socket.emit(topic, items)
    }
    
    /// Disconnects from the websocket server
    public static func disconnect() {
        SocketService.Socket.disconnect()
    }
}
