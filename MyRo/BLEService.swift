//
//  BLEService.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//

import CoreBluetooth

class BLEService: NSObject {
    private var connectedPeripheral: CBPeripheral!
    private var characteristic: CBCharacteristic!
    
    init(peripheral: CBPeripheral) {
        super.init()
        
        self.connectedPeripheral = peripheral
        self.connectedPeripheral.delegate = self
    }
    
    func sendData(data: NSData) {
        guard self.characteristic != nil else { return }
        
        self.connectedPeripheral.writeValue(data, forCharacteristic: self.characteristic, type: .WithResponse)
    }
}

extension BLEService: CBPeripheralDelegate {
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        guard let services = peripheral.services where error == nil && self.connectedPeripheral == peripheral else { return }
        
        for service in services {
            self.peripheral(peripheral, didDiscoverCharacteristicsForService: service, error: nil)
        }
        //peripheral.discoverCharacteristics(nil, forService: service)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        guard let characteristic = service.characteristics?.first where error == nil && self.connectedPeripheral == peripheral else { return }
        
        peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        self.characteristic = characteristic
    }
}
