//
//  Int+Extension.swift
//  SAEAL
//
//  Created by 김유진 on 12/5/23.
//

import Foundation

extension Int {
    func yearFormatterString() -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = .none
        return numberFommater.string(for: self)
    }
    
    func timeFormatterString() -> String? {
        if self / 100 > 0 {
            return String(self)
        }
        
        return String(format: "%02d", self)
    }
}
