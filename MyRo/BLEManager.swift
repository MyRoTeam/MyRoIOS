//
//  BLEManager.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//  Copyright © 2016 ISBX. All rights reserved.
//

import CoreBluetooth

class BLEManager {
    static let sharedManager = BLEManager()
    
    var centralManager: CBCentralManager!
    var handler: BLEHandler!
    
    private let centralManagerQueue = dispatch_queue_create("com.myro.ble", nil)
    
    init() {
        self.handler = BLEHandler()
        self.centralManager = CBCentralManager(delegate: self.handler, queue: self.centralManagerQueue)
    }
    
    func sendData(data: NSData) {
        guard self.handler != nil else { return }
        self.handler.sendData(data)
    }
}
