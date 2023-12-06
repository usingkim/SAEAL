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
    @State private var isPickingYear: Bool = false
    @State private var isPopupVisible: Bool = false
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            
            HStack(spacing: 0) {
                Button(action: {
                    isPickingYear = true
                }, label: {
                    if let y = year.yearFormatterString() {
                        Text("\(y)년")
                            .font(.title05)
                    }
                    Image(.expandMore)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .foregroundColor(Color.color1)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isPickingYear, content: {
                HStack {
                    Spacer()
                    Button(action: {
                        isPickingYear = false
                    }, label: {
                        Text("완료")
                            .font(.body03)
                    })
                    .foregroundColor(Color.color1)
                    .padding(.trailing, 16)
                }
                Picker(selection: $year, label: Text("기간")) {
                    ForEach(years, id:\.self) { year in
                        if let y = year.yearFormatterString() {
                            Text("\(y)년").tag(year)
                                .font(.body01)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .presentationDetents([.fraction(0.4)])
            })
            
            
            Spacer()
            
            if myMediaService.myMovies.isEmpty {
                VStack(spacing: 0, content: {
                    Text("영화 기록을 시작해보세요!")
                    Text("검색 탭으로 이동해 관심있는 영화를 검색해봐요!")
                })
                .font(.body01)
                Spacer()
            }
            else {
                HStack(alignment: .top, spacing: 2) {
                    Text("Total")
                        .font(.caption01)
                    Button(action: {
                        isPopupVisible = true
                    }, label: {
                        Image(systemName: "info.circle")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: 5, height: 5)
                    })
                    .popover(isPresented: $isPopupVisible, content: {
                        Text("나의 러닝타임은 다 본 영화의 러닝타임만을 책정합니다.")
                            .font(.body04)
                            .padding()
                            .presentationCompactAdaptation(.popover)
                    })
                    
                }
                .padding(.bottom, 10)
                Text("\(intToHour(runtime: myMediaService.myRunningTime))시간 \(intToMinute(runtime: myMediaService.myRunningTime))분")
                    .font(.headline1)
                
                Spacer()
                
                HStack {
                    Text("월별 러닝 타임")
                        .font(.title04)
                        
                    Spacer()
                }
                .padding(.leading, 15)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(myMediaService.monthlyRunningTime, id: \.self) { runtime in
                        VStack {
                            Text("\(runtime[0])월")
                                .font(.title05)
                            if let hour = intToHour(runtime: runtime[1]).timeFormatterString() {
                                if let minute = intToMinute(runtime: runtime[1]).timeFormatterString() {
                                    Text("\(hour):\(minute)")
                                        .font(.body01)
                                }
                            }
                        }
                    }
                }
                .padding(10)
                
//                MonthlyGraphView(myMediaService: myMediaService)
//                    .padding()
//                    .frame(width: 350, height: 250)
//                    .background {
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.color5)
//                    }
            }
            
            
            
//            Spacer()
        }
        .onAppear {
            myMediaService.resetRunningTime(startDate: calendarToDate(year: year, month: 1, day: 1, isStart: true), endDate: calendarToDate(year: year, month: 12, day: 31, isStart: false))
        }
        .onChange(of: year, perform: { value in
            myMediaService.resetRunningTime(startDate: calendarToDate(year: year, month: 1, day: 1, isStart: true), endDate: calendarToDate(year: year, month: 12, day: 31, isStart: false))
        })
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

#Preview {
    ViewingTimeView(myMediaService: MyMediaService())
}
