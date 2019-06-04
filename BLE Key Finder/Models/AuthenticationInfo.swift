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
    let firstName: String?
    let lastName: String?
    let user: String?
    
    private enum CodingKeys: String, CodingKey {
        case hubId
        case first_name
        case last_name
        case user
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hubId = try container.decode(String.self, forKey: .hubId)
        firstName = try container.decodeIfPresent(String.self, forKey: .first_name)
        lastName = try container.decodeIfPresent(String.self, forKey: .last_name)
        user = try container.decodeIfPresent(String.self, forKey: .user)
    }
}
