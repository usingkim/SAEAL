//
//  ViewingTimeView.swift
//  SAEAL
//
//  Created by 김유진 on 11/11/23.
//

import SwiftUI

struct ViewingTimeView: View {
    @ObservedObject var myMediaService: MyMediaService
    
    let years = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
    @State private var year: Int = 2023
    
    var body: some View {
        VStack {
            HStack {
                Text("기간")
                Picker(selection: $year, label: Text("기간")) {
                    ForEach(years, id:\.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            if myMediaService.myRunningTime == -1 {
                Text("영화 기록을 시작해보세요!")
                Text("검색 후 저장을 시작하시면 됩니다!")
            }
            else {
                Text("\(myMediaService.myRunningTime / 60)시간 \(myMediaService.myRunningTime % 60)분")
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            myMediaService.resetRunningTime(startDate: calendarToDate(year: year, month: 1, day: 1, isStart: true), endDate: calendarToDate(year: year, month: 12, day: 31, isStart: false))
        }
        .onChange(of: year, perform: { value in
            myMediaService.resetRunningTime(startDate: calendarToDate(year: year, month: 1, day: 1, isStart: true), endDate: calendarToDate(year: year, month: 12, day: 31, isStart: false))
        })
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

#Preview {
    ViewingTimeView(myMediaService: MyMediaService())
}