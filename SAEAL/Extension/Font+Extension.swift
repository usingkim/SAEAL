//
//  Font+Extension.swift
//  SAEAL
//
//  Created by 김유진 on 11/29/23.
//

import Foundation

import SwiftUI

extension Font {
    /// Bold, size 40
    static var dotumBold1: Font {
        return Font.custom("KoPubWorld돋움체_Pro Bold", size: 20)
    }
    
    static var dotumLight1: Font {
        return Font.custom("KoPubWorld Dotum_Pro Light", size: 20)
    }
    
    static var dotumMedium1: Font {
        return Font.custom("KoPubWorld Dotum_Pro Medium", size: 20)
    }
    
    static var wooju1: Font {
        return Font.custom("학교안심 우주 R", size: 20).bold()
    }
}

