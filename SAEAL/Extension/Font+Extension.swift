//
//  Font+Extension.swift
//  SAEAL
//
//  Created by 김유진 on 11/29/23.
//

import Foundation
import SwiftUI

extension Font {
    static func dotumBold(size: CGFloat) -> Font {
        return Font.custom("KoPubWorldDotumPB", size: size)
    }
    
    static func dotumMedium(size: CGFloat) -> Font {
        return Font.custom("KoPubWorldDotumPM", size: size)
    }
    
    static func dotumLight(size: CGFloat) -> Font {
        return Font.custom("KoPubWorldDotumPM", size: size)
    }
    
    static func wooju(size: CGFloat) -> Font {
        return Font.custom("HakgyoansimWoojuR", size: size)
    }
}
