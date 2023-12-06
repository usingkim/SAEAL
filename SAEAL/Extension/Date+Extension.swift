//
//  Date+Extension.swift
//  SAEAL
//
//  Created by 김유진 on 12/5/23.
//

import Foundation

extension Date {
    private static let defaultPreferredLanguage = "ko-kr"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Self.defaultPreferredLanguage)
        return formatter
    }()
    
    var yearMonthDay: String {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return Self.dateFormatter.string(from: self)
    }
}
