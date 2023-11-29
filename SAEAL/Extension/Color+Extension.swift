//
//  Color+Extension.swift
//  SAEAL
//
//  Created by 김유진 on 11/29/23.
//

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    /// #29353C
    static let color1 = Color(hex: "#29353C")
    
    /// #44576D
    static let color2 = Color(hex: "#44576D")
    
    /// #768A96
    static let color3 = Color(hex: "#768A96")
    
    /// #AAC7D8
    static let color4 = Color(hex: "#AAC7D8")
    
    /// #DFEBF6
    static let color5 = Color(hex: "#DFEBF6")
    
    /// #E6E6E6
    static let color6 = Color(hex: "#E6E6E6")
}
