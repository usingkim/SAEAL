//
//  ViewingTimeViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/21/23.
//

import Foundation

final class ViewingTimeViewModel: ObservableObject {
    let years = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
    @Published var year: Int = 2023
    @Published var isPickingYear: Bool = false
    @Published var isPopupVisible: Bool = false
    
    func getYearString() -> String? {
        return year.yearFormatterString()
    }
    
    func getTimeStringWithKorean(time: Int) -> String {
        return "\(intToHour(runtime: time))시간 \(intToMinute(runtime: time))분"
    }
    
    func getTimeString(time: Int) -> String {
        if let hour = intToHour(runtime: time).timeFormatterString() {
            if let minute = intToMinute(runtime: time).timeFormatterString() {
                return "\(hour):\(minute)"
            }
        }
        
        return ""
    }
    
    func intToHour(runtime: Int) -> Int {
        return runtime / 60
    }
    
    func intToMinute(runtime: Int) -> Int {
        return runtime % 60
    }
    
    func calendarToDate(year: Int, month: Int, day: Int, isStart: Bool)->Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        if isStart {
            components.hour = 0
            components.minute = 0
            components.second = 0
        }
        else {
            components.hour = 23
            components.minute = 59
            components.second = 59
        }

        if let date = Calendar.current.date(from: components) {
            return date
        }
        
        return Date.now
    }
}
