//
//  MyMediaDetailView.swift
//  SAEAL
//
//  Created by 김유진 on 11/20/23.
//

import SwiftUI

struct MyMediaDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var myMediaService: MyMediaService
    @State var movie: DBMovie
    
    @State private var isShowingEditSheet: Bool = false
    @State private var status: DBMovie.Status = .bookmark
    @State private var watchedTime: Double = 0
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, content: {
                    Text(movie.title)
                        .font(.dotumBold(size: 25))
                    Text("\(movie.releaseDate), \(movie.runtime)분")
                        .font(.dotumMedium(size: 15))
                    Text("감독 : \(movie.director)")
                        .font(.dotumMedium(size: 15))
                    
                    Text("주요 출연진")
                        .font(.dotumMedium(size: 15))
                    ForEach(movie.actors, id:\.self) { actor in
                        Text("- \(actor) ")
                            .font(.dotumMedium(size: 15))
                    }
                    
                    Spacer()
                })
                .frame(height: 150)
                
                Spacer()
                
                VStack {
                    Image(.film)
                        .resizable()
                        .frame(width: 100, height: 150)
                    Spacer()
                }
            }
            
            HStack {
                VStack(alignment: .leading, content: {
                    Text("줄거리")
                        .font(.dotumBold(size: 20))
                    Text("\(movie.overview)")
                        .font(.dotumMedium(size: 15))
                })
                Spacer()
            }
            
            
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isShowingEditSheet = true
                }, label: {
                    Text("수정")
                })
                .sheet(isPresented: $isShowingEditSheet, content: {
                    editSheet
                        .onAppear {
                            if let s = DBMovie.Status.getStatusByInt(movie.status) {
                                status = s
                            }
                            
                            if let s = movie.startDate {
                                startDate = s
                            }
                            
                            if let e = movie.endDate {
                                endDate = e
                            }
                        }
                        .presentationDetents([.medium])
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
//                    myMediaService.delMovie(movie: movie)
                    dismiss()
                }, label: {
                    Text("삭제")
                })
            }
        })
    }
    
    var editSheet: some View {
        VStack {
            HStack {
                ForEach(DBMovie.Status.allCases, id:\.self) { s in
                    Button {
                        status = s
                    } label: {
                        Text(s.statusString)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("\(status.statusString)")
            
            if status == .ing {
                HStack {
                    Text("0")
                    Slider(value: $watchedTime, in: 0...Double(movie.runtime), step: 1)
                    
                    Text("\(movie.runtime)")
                }
                
                Text("\(Int(watchedTime))분")
                
                DatePicker(selection: $startDate, displayedComponents: .date) {
                    Text("시작 날짜")
                }
            }
            
            else if status == .end {
                Text("\(Int(watchedTime))분")
                
                DatePicker(selection: $startDate, displayedComponents: .date) {
                    Text("시작 날짜")
                }
                DatePicker("끝난 날짜", selection: $endDate, in: startDate...(Calendar.current.date(byAdding: .year, value: 1, to: startDate) ?? startDate), displayedComponents: .date)
            }
            
            Button {
                // TODO: 이미 나의 필모그래피에 있는 경우
                // 이미 나의 필모그래피에 존재합니다. 2회차를 감상하시겠습니까?
                
                let newMovie = DBMovie(movie: movie)
                newMovie.touchedTime = Date.now
                
                switch(status) {
                case .bookmark:
                    newMovie.status = DBMovie.Status.bookmark.rawValue
                    newMovie.myRuntime = 0
                    newMovie.startDate = nil
                    newMovie.endDate = nil
                case .ing:
                    newMovie.status = DBMovie.Status.ing.rawValue
                    newMovie.myRuntime = Int(watchedTime)
                    newMovie.startDate = startDate
                    newMovie.endDate = nil
                case .end:
                    newMovie.status = DBMovie.Status.end.rawValue
                    newMovie.myRuntime = movie.runtime
                    newMovie.startDate = startDate
                    newMovie.endDate = endDate
                }
                myMediaService.editMovie(oldMovie: movie, newMovie: newMovie)
                isShowingEditSheet = false
                dismiss()
            } label: {
                Text("저장")
            }
        }
    }
}

#Preview {
    MyMediaDetailView(myMediaService: MyMediaService(), movie: DBMovie(title: "태어난 김에 세계일주 3", MovieID: 0, runtime: 235, posterLink: nil, touchedTime: Date.now, releaseDate: "2023-03-21", overview: "모두 끝나버렸다 난 시작도 안해봤는데", status: 0, actors: ["정우성", "김유진"], director: "김유진", myRuntime: 0, startDate: nil, endDate: nil))
}
