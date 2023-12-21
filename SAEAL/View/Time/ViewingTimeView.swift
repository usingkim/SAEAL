//
//  ViewingTimeView.swift
//  SAEAL
//
//  Created by 김유진 on 11/11/23.
//

import SwiftUI

struct ViewingTimeView: View {
    
    @StateObject var viewingTimeVM: ViewingTimeViewModel = ViewingTimeViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            viewingTime
            
            if viewingTimeVM.isPopupVisible {
                Text("나의 러닝타임은 다 본 영화의 러닝타임만을 책정합니다.")
                    .font(.body04)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .onTapGesture {
                        viewingTimeVM.isPopupVisible.toggle()
                    }
            }
        }
    }
    
    var viewingTime: some View {
        VStack {
            
            HStack(spacing: 0) {
                Button(action: {
                    viewingTimeVM.isPickingYear = true
                }, label: {
                    if let y = viewingTimeVM.getYearString() {
                        Text("\(y)년")
                            .font(.title05)
                    }
                    Image(.expandMore)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .foregroundColor(Color.color1)
                .sheet(isPresented: Binding<Bool>(
                    get: { self.viewingTimeVM.isPickingYear },
                    set: { self.viewingTimeVM.isPickingYear = $0 }
                ), content: {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewingTimeVM.isPickingYear = false
                        }, label: {
                            Text("완료")
                                .font(.body03)
                        })
                        .foregroundColor(Color.color1)
                        .padding(.trailing, 16)
                    }
                    Picker(selection: Binding<Int>(
                        get: { self.viewingTimeVM.year },
                        set: { self.viewingTimeVM.year = $0 }
                    ), label: Text("기간")) {
                        ForEach(viewingTimeVM.years, id:\.self) { year in
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
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            
            
            
            Spacer()
            
            if viewingTimeVM.Movies.isEmpty {
                VStack(spacing: 0, content: {
                    Text("영화 기록을 시작해보세요!")
                    Text("검색 탭으로 이동해 관심있는 영화를 검색해봐요!")
                })
                .font(.body01)
                Spacer()
            }
            else {
                HStack {
                    Text("Total")
                        .font(.caption01)
                    Button(action: {
                        viewingTimeVM.isPopupVisible = true
                    }, label: {
                        Image(systemName: "info.circle")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: 10, height: 10)
                    })
                }
                .padding(.bottom, 10)
                    
                Text(viewingTimeVM.getTimeStringWithKorean())
                    .font(.headline1)
                
                Spacer()
                
                HStack {
                    Text("월별 러닝 타임")
                        .font(.title04)
                        
                    Spacer()
                }
                .padding(.leading, 15)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewingTimeVM.monthlyRunningTime, id: \.self) { runtime in
                        VStack {
                            Text("\(runtime[0])월")
                                .font(.title05)
                            Text(viewingTimeVM.getTimeString(time: runtime[1]))
                                .font(.body01)
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
            viewingTimeVM.fetchAllMovie()
            viewingTimeVM.resetRunningTime(startDate: viewingTimeVM.calendarToDate(year: viewingTimeVM.year, month: 1, day: 1, isStart: true), endDate: viewingTimeVM.calendarToDate(year: viewingTimeVM.year, month: 12, day: 31, isStart: false))
        }
        .onChange(of: viewingTimeVM.year, perform: { value in
            viewingTimeVM.resetRunningTime(startDate: viewingTimeVM.calendarToDate(year: viewingTimeVM.year, month: 1, day: 1, isStart: true), endDate: viewingTimeVM.calendarToDate(year: viewingTimeVM.year, month: 12, day: 31, isStart: false))
        })
    }
    
}

#Preview {
    ViewingTimeView()
}
