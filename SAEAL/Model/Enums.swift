//
//  enums.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

enum Status: CaseIterable {
    case bookmark
    case ing
    case end
    
    var statusString: String {
        switch(self){
        case .bookmark:
            return "보고싶어요!"
        case .ing:
            return "쉿! 보는중!"
        case .end:
            return "다 봤어요!"
        }
    }
}

enum MediaType {
    case drama
    case movie
}
