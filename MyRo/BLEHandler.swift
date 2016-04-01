//
//  BLEHandler.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//

import CoreBluetooth

class BLEHandler: NSObject, CBCentralManagerDelegate {
    var peripheral: CBPeripheral!
    var service: BLEService!
    
    override init() {
        super.init()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("BLE STATE")

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
    
    func sendData(data: NSData) {
        guard self.service != nil else { return }
        self.service.sendData(data)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("BLE discovered: \(peripheral.name) : \(RSSI)")
        
        if ((self.peripheral == nil || self.peripheral.state == .Disconnected) && peripheral.name == "HMSoft") {
            print("FOUND")
            self.peripheral = peripheral
            self.service = BLEService(peripheral: peripheral)
            central.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected Peri")
        self.service = nil
        central.stopScan()
        
        
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected Peri")

        central.scanForPeripheralsWithServices(nil, options: nil)
    }
}
