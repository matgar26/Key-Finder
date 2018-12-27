//
//  AuthenticationInfo.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/24/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation

public struct AuthenticationInfo: Decodable {
    let hubId: String?
    let key: String?
}
