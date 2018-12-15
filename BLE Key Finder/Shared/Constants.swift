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
        
        static let mapInfoViewHeight: CGFloat = Metrics.screenHeight - Metrics.tabBarHeight - Metrics.navigationBarHeight - 30
    }
    
    struct Keys {
        // Keychain Keys
        static let service = "https://refactor-active-oversight.herokuapp.com/"
        static let authToken = "token"
        static let userID = "id"
        // User Default Keys
        static let currentCompanyId = "CurrentCompanyId"
        static let currentCompanyName = "CurrentCompanyName"
        static let currentCompanyColor = "CurrentCompanyColor"
        static let filterDefaults = "FilterDefaults"
        // Reachability
        static let connectionLost = "connectionLost"
        static let connectionGained = "connectionGained"
        static let oneSignalPlayerId = ""
    }
    
    struct Urls {
        static let local = "http://10.0.2.204:3000/"
        static let baseUrl = "https://ao-staging-api.finalze.com/"
        static let dev = "https://ao-dev-api.finalze.com/"
        static let qa = "https://ao-qa-api.finalze.com/"
        static let staging = "https://ao-staging-api.finalze.com/"
        static let prod = "https://ao-api.finalze.com/"
        static let forgotPassword = "https://ao-staging.finalze.com/forgot-password"
    }
}
