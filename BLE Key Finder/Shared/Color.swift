//
//  Color.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/14/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    
    private init() {}
    
    static func highlighted(_ color: UIColor) -> UIColor {
        return color.withAlphaComponent(0.8)
    }
    
    static func hex(_ string: String) -> UIColor {
        return UIColor(hexString: string)
    }
    
    // MARK: - Application Colors
    
    static let primary = UIColor(hexString: "3c3075")
    static let primaryGradient = UIColor(hexString: "17122d")
    static let secondary = UIColor(hexString: "e09916")
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

