//
//  BLEManager.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//

import CoreBluetooth

/// Class that handles all BluetoothLE interactions
class BLEManager {
    /// Global shared instance of BLEManager
    static let sharedManager = BLEManager()
    
    /// Bluetooth central manager to scan for nearby bluetooth device
    var centralManager: CBCentralManager!
    
    /// Bluetooth central manager delegate handler
    var handler: BLEHandler!
    
    /// Queue that the centralManager runs on
    private let centralManagerQueue = dispatch_queue_create("com.myro.ble", nil)
    
    init() {
        self.handler = BLEHandler()
        self.centralManager = CBCentralManager(delegate: self.handler, queue: centralManagerQueue)
    }
    
    /**
     Sends the data provided to the connected peripheral
     
     - parameter data: Data to send to the connected peripheral
     */
    func sendData(data: NSData) {
        guard self.handler != nil else { return }
        self.handler.sendData(data)
    }
}
