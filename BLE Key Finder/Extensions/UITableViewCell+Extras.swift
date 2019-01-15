//
//  UITableViewCell+Extras.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 1/14/19.
//  Copyright © 2019 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
