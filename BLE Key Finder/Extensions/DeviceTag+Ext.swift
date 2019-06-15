//
//  DeviceTag+Ext.swift
//  BLE Key Finder
//
//  Created by Jake Wagstaff on 6/14/19.
//  Copyright © 2019 Matt Gardner. All rights reserved.
//

import Foundation

extension DeviceTag {
    func deviceTagParameters() -> [String: Any] {
        return [
            "macAddress": device.stringValueFor(.macAddress),
            "nodeId": device.stringValueFor(.deviceId),
            "rssi": device.stringValueFor(.rssi),
            "distance": device.stringValueFor(.distance),
            "battery": device.stringValueFor(.battery),
            "name": device.stringValueFor(.name)
        ]
    }
}
