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
    
    // MARK: Grays
    
    /// Lightest gray.
    ///
    /// Used in form cells, input bars, bar backgrounds,
    /// section headers, login fields.
    ///
    /// `FAFAFA`
    static let lightBackground = UIColor(hexString: "FAFAFA")
    
    /// Light gray (slightly darker than `lightBackground`).
    ///
    /// Used in table cell separators, borders and separator lines
    /// in views who typically have a `lightBackground`.
    ///
    /// `D9D9D9`
    static let lightTrim = UIColor(hexString: "D9D9D9")
    
    /// Medium-light gray (slightly lighter than `inactive`).
    ///
    /// Used by seprators in form sections.
    ///
    /// `C7C7C7`
    static let mediumTrim = UIColor(hexString: "C7C7C7")
    
    /// Medium gray.
    ///
    /// Used by message bar icons in their normal states,
    /// text field placeholders
    ///
    /// `AEAEAE`
    static let inactive = UIColor(hexString: "AEAEAE")
    
    /// `inactive` with alpha `0.4`
    ///
    /// Used by message bar icons in their disabled states.
    ///
    static let disabled = Color.inactive.withAlphaComponent(0.4)
    
    /// Dark gray (darker than `lightTrim`).
    ///
    /// Used in borders and separator lines in views
    /// who typically have a `lightBackground`.
    ///
    /// `9B9B9B`
    static let darkTrim = UIColor(hexString: "9B9B9B")
    
    /// Off-black, very dark gray (darker than `darkTrim`).
    ///
    /// Used in labels where the text almost looks black.
    ///
    /// `444444`
    static let offBlack = UIColor(hexString: "444444")
    
    // MARK: - Search Bars
    
    /// Colors specific to search bars.
    struct SearchBar {
        
        private init() {}
        
        /// Light gray. `F7F7F7`
        static let background = UIColor(hexString: "F7F7F7")
        
        /// Dark gray. `7A797B`
        static let placeholder = UIColor(hexString: "7A797B")
    }
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

