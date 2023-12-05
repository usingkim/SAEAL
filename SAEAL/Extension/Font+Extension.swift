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
    
    /// Bold / 40
    static var headline1: Font {
        return Font.custom("Pretendard-Bold", size: 40)
    }
    /// Bold / 38
    static var title01: Font {
        return Font.custom("Pretendard-Bold", size: 38)
    }
    /// Bold / 36
    static var title02: Font {
        return Font.custom("Pretendard-Bold", size: 36)
    }
    /// Bold / 32
    static var title03: Font {
        return Font.custom("Pretendard-Bold", size: 32)
    }
    /// Bold / 26
    static var title04: Font {
        return Font.custom("Pretendard-Bold", size: 26)
    }
    /// Bold / 18
    static var title05: Font {
        return Font.custom("Pretendard-Bold", size: 18)
    }
    /// SemiBold / 16
    static var body01: Font {
        return Font.custom("Pretendard-SemiBold", size: 16)
    }
    /// Bold / 14
    static var body02: Font {
        return Font.custom("Pretendard-Bold", size: 14)
    }
    /// SemiBold / 14
    static var body03: Font {
        return Font.custom("Pretendard-SemiBold", size: 14)
    }
    /// Medium / 14
    static var body04: Font {
        return Font.custom("Pretendard-Medium", size: 14)
    }
    /// Bold / 12
    static var caption01: Font {
        return Font.custom("Pretendard-Bold", size: 12)
    }
    /// Medium / 12
    static var caption02: Font {
        return Font.custom("Pretendard-Medium", size: 12)
    }
    /// Bold / 10
    static var caption03: Font {
        return Font.custom("Pretendard-Bold", size: 10)
    }
}
