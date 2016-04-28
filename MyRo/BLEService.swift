//
//  BLEService.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//

import CoreBluetooth

/// Service class that handles all communication to a connected peripheral
class BLEService: NSObject {
    /// Currently connected peripheral
    private var connectedPeripheral: CBPeripheral!
    
    /// Currently connected peripheral's characteristic
    private var characteristic: CBCharacteristic!
    
    init(peripheral: CBPeripheral) {
        super.init()
        
        self.connectedPeripheral = peripheral
        self.connectedPeripheral.delegate = self
        self.connectedPeripheral.discoverServices(nil)
    }
    
    /**
     Sends the data provided to the connected peripheral's characteristic
     
     - parameter data: Data to send to the connected peripheral's characteristic
     */
    func sendData(data: NSData) {
        print("HERE")
        guard self.characteristic != nil else {
            print("Characteristic is Nil")
            return
        }
        
        print("Sending Data to Characteristic: \(self.characteristic.UUID.UUIDString)")
        self.connectedPeripheral.readValueForCharacteristic(self.characteristic)
        self.connectedPeripheral.writeValue(data, forCharacteristic: self.characteristic, type: .WithoutResponse)
        
    }
}

/// Extension that handles CBPeripheralDelegate
extension BLEService: CBPeripheralDelegate {
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("Sends: \(error?.description)")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        guard let services = peripheral.services where error == nil && self.connectedPeripheral == peripheral else { return }
        
        for service in services {
            if (service.UUID.UUIDString == "FFE0") {
                print("Found Service: \(service.UUID.UUIDString)")
                peripheral.discoverCharacteristics(nil, forService: service)
                //self.peripheral(peripheral, didDiscoverCharacteristicsForService: service, error: nil)
            }
        }
        //peripheral.discoverCharacteristics(nil, forService: service)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        guard let characteristics = service.characteristics where error == nil && self.connectedPeripheral == peripheral else { return }
        
        for characteristic in characteristics {
            if (characteristic.UUID.UUIDString == "FFE1") {
                print("Found Characteristic: \(characteristic.UUID.UUIDString)")
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                self.characteristic = characteristic
                
                //let dataStr = "XFY250"
                //self.sendData(NSData(bytes: ["X"] as [Character], length: 1))
                //self.sendData(dataStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        
                /*self.sendData(NSData(bytes: ["H"] as [Character], length: 1))
                self.sendData(NSData(bytes: [11] as [UInt8], length: 1))
                self.sendData(NSData(bytes: [100] as [UInt8], length: 1))*/
            }
        }
    }
}
