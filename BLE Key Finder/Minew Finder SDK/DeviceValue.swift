//
//  DeviceValue.swift
//  BLE Key Finder
//
//  Created by Jacob Wagstaff on 12/16/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation

enum DeviceValue : Int {
    //   Device propertys
    //                                    type        permission      note
    // custom name
    case _Name = 1 //    stringValue    W/R
    // headimage
    case _HeadImage //    dataValue     W/R             a NSData instance of image
    // device name
    case _DeviceId //    stringValue    R              F2 / F3
    // mac address
    case _MacAddress //    stringValue    R
    // rssi
    case _Rssi //    intValue       R
    // mode  using mode
    case _Mode //    intValue      W/R            1, 2
    // distance
    case _Distance //    floatValue     R
    // battery level
    case _Battery //    intValue       R
    // bind status
    case _Bind //    boolValue      R
    // you can get last time of device disconnect
    case _DisappearTime //    stringValue    R             yyyy-MM-dd hh:mm:ss
    // you can get last longitude of device disconnect
    case _DisappearLong //    floatValue     R
    // you can get last latitude of device disconnect
    case _DisappearLati //    floatValue     R
    // if device connected
    case _Connected //    boolValue      R
    // when device disconnect if it alert, see the demo
    case _DeviceLoseAlert //    boolValue      R / W
    // if app is searching the device
    case _Search //    boolValue      R
    // when device disconnect if app alert, see the demo
    case _AppLoseAlert //    boolValue      R / W
    // if device support set alarmdelay and alarmdistance
    case _FeatureSupport //    boolValue      R
    // control disconnect distance between device and iPhone
    case _AlarmDistance //    intValue       R / W        1 - 8
    // control alarm delay time when disconnect.
    case _AlarmDelay //    intValue       R / W        0 - 8
    // Device data handle
    case _DeviceData = 1000 //    dataValue      R
    
    func intValueFor(value: DeviceValue) -> Int {
        return value.rawValue
    }
}
