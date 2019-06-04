//
//  Constants.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Metrics {
        static let navigationBarHeight: CGFloat = 70
        static let tabBarHeight: CGFloat = 50
        
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
    
    struct Keys {
        // Keychain Keys
        static let service = "http://api.findersolutions.com/echolo/mobile/"
        static let hubId = "id"

        // Reachability
        static let connectionLost = "connectionLost"
        static let connectionGained = "connectionGained"
        static let oneSignalPlayerId = ""
    }
    
    struct Urls {
        static let dev = "http://api.findersolutions.com/echolo/mobile/"
        static let prod = "http://api.findersolutions.com/echolo/mobile/"
    }
}
