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
    
    @Published var Movies: [DBMovie] = []
    @Published var myRunningTime: Int = -1
    @Published var monthlyRunningTime = (1...12).map { [$0, 0] }
    
    func getYearString() -> String? {
        return year.yearFormatterString()
    }
    
    func getTimeStringWithKorean() -> String {
        return "\(intToHour(runtime: myRunningTime))시간 \(intToMinute(runtime: myRunningTime))분"
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
    
    func fetchAllMovie() {
        Movies = Array(realm.objects(DBMovie.self))
    }
    
    func resetRunningTime(startDate: Date, endDate: Date) {
        if Movies.isEmpty {
            myRunningTime = 0
            monthlyRunningTime = (1...12).map { [$0, 0] }
            return
        }
        
        myRunningTime = 0
        monthlyRunningTime = (1...12).map { [$0, 0] }
        for movie in Movies {
            if let end = movie.endDate {
                if startDate...endDate ~= end {
                    myRunningTime += movie.myRuntime
                    if let month = Calendar.current.dateComponents([.month], from: end).month {
                        monthlyRunningTime[month - 1][1] += movie.myRuntime
                    }
                }
            }
        }
    }
}
