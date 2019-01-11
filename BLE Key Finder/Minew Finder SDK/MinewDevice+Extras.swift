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
}
