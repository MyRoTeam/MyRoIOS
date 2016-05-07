//
//  BLEHandler.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import CoreBluetooth

/// Central manager delegate handler
class BLEHandler: NSObject, CBCentralManagerDelegate {
    /// Currently connected peripheral
    var peripheral: CBPeripheral!
    
    /// Currently connected peripheral's service
    var service: BLEService!
    
    override init() {
        super.init()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case .PoweredOn:
            print("BLE on")
            print("BLE Begin scanning")
            central.scanForPeripheralsWithServices(nil, options: nil)
            break
            
        case .PoweredOff:
            print("BLE off")
            break
        
        case .Resetting:
            print("BLE resetting")
            break
            
        case .Unauthorized:
            print("BLE unauthorized")
            break
            
        case .Unsupported:
            print("BLE unsupported")
            break
            
        case .Unknown:
            print("BLE unknown")
            break
        }
    }
    
    /**
     Sends the provided data to the current BLE service
     
     - parameter data: Data to send to the current BLE service
     */
    func sendData(data: NSData) {
        guard self.service != nil else { return }
        self.service.sendData(data)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("BLE discovered: \(peripheral.name) : \(RSSI)")
        
        if ((self.peripheral == nil || self.peripheral.state == .Disconnected) && peripheral.name == "HMSoft") {
            print("\(peripheral.name) found")
            self.peripheral = peripheral
            //self.service = BLEService(peripheral: peripheral)
            central.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name)")
        //self.service = nil
        self.service = BLEService(peripheral: peripheral)
        central.stopScan()
        
        /*self.service.sendData(NSData(bytes: ["H"] as [Character], length: 1))
        self.service.sendData(NSData(bytes: [11] as [UInt8], length: 1))
        self.service.sendData(NSData(bytes: [200] as [UInt8], length: 1))*/

    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from peripheral: \(peripheral.name)")

        central.scanForPeripheralsWithServices(nil, options: nil)
    }
}
