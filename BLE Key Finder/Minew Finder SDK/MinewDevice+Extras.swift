//
//  MinewDevice+Extras.swift
//  BLE Key Finder
//
//  Created by Jacob Wagstaff on 1/11/19.
//  Copyright © 2019 Matt Gardner. All rights reserved.
//

import Foundation

extension MinewDevice {
    func isConnected() -> Bool {
        let isConnected = getValue(.connected)?.stringValue
        let boolConnect = Bool(isConnected!) ?? false
        return boolConnect
    }
    
    
    func stringValueFor(_ value: ValueIndex) -> String {
        return self.getValue(value)?.stringValue ?? ""
    }
    
    var distance: String? {
        let distance = self.getValue(.distance)?.floatValue ?? nil
        if distance != nil {
            return String(distance!)
        }
        return nil
    }
    
    var distanceInFeet: String? {
        if let distance = self.getValue(.distance)?.floatValue ?? nil {
            let feet = distance * 3.2808
            return "\(feet.rounded())ft"
        }
        return nil
    }
    

}

extension DeviceTag {
    func isConnected() -> Bool {
        let isConnected = device.getValue(.connected)?.stringValue
        let boolConnect = Bool(isConnected!) ?? false
        return boolConnect
    }

    func stringValueFor(_ value: ValueIndex) -> String {
        return device.getValue(value)?.stringValue ?? ""
    }
    
    var distance: String? {
        let distance = device.getValue(.distance)?.floatValue ?? nil
        if distance != nil {
            return String(distance!)
        }
        return nil
    }
    
    var rssiDistance: String {
        if let rssi = device.getValue(.rssi)?.intValue {
            let positiveRssi = rssi * -1
            if positiveRssi <= 42 {
                return "Immediate"
            }
            if positiveRssi <= 70 {
                return "Near"
            }
            return "Far"
        }
        if !isConnected() {
            return "Disconnected"
        }
        return "Unknown"
    }
    
    var distanceInFeet: String? {
        if let distance = device.getValue(.distance)?.floatValue {
            let feet = distance * 3.2808
            return "\(feet.rounded())ft"
        }
        return nil
    }
}
