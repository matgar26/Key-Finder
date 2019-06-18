//
//  Optional+Extras.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
            
        case .some(let string):
            return string.isEmpty
        }
    }
}
