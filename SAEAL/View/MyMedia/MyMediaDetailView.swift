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
    @State private var isShowingDeleteAlertSheet: Bool = false
    @State private var isShowingBookmarkAlert: Bool = false
    @State private var status: DBMovie.Status? = .bookmark
    @State private var watchedTime: Double = 0
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    
    
    var body: some View {
        VStack {
            
            MovieDetailSubView(movie: movie)
            
            HStack(spacing: 30) {
                ForEach(DBMovie.Status.allCases, id:\.self) { s in
                    Button {
                        if s != .bookmark {
                            isShowingEditSheet = true
                        }
                        else {
                            isShowingBookmarkAlert = true
                        }
                        status = s
                    } label: {
                        VStack {
                            Image(s.getStatusImageString())
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(s == status ? Color.black : Color.gray)
                            Text(s.statusString)
                                .font(.body02)
                                .foregroundStyle(s == status ? Color.black : Color.gray)
                        }
                    }
                    .buttonStyle(.plain)
                    .alert(isPresented: $isShowingBookmarkAlert, content: {
                        changeAlert
                    })
                    
                }
//                Button {
//                    isShowingDeleteAlertSheet = true
//                } label: {
//                    VStack {
//                        Image(systemName: "xmark")
//                            .renderingMode(.template)
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundStyle(Color.red)
//                            .padding(.bottom, 10)
//                        Text("삭제")
//                            .font(.body02)
//                            .foregroundStyle(Color.red)
//                    }
//                }
//                .alert(isPresented: $isShowingDeleteAlertSheet, content: {
//                    Alert(title: Text("나의 필모그래피에서 삭제하시겠습니까?"),
//                          primaryButton: .destructive(Text("삭제") , action: {
//                        myMediaService.delMovie(movie: movie)
//                        dismiss()
//                    }),
//                          secondaryButton: .cancel(Text("취소"), action: {
//                        isShowingDeleteAlertSheet = false
//                    })
//                    )
//                })

            }
            
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, content: {
                    Text("줄거리")
                        .font(.title04)
                        .padding(.bottom, 10)
                    Text("\(movie.overview)")
                        .font(.body03)
                        .padding(.leading, 5)
                })
                Spacer()
            }
            
            
            
            Spacer()
        }
        .onAppear {
            status = DBMovie.Status.getStatusByInt(movie.status)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .sheet(isPresented: $isShowingEditSheet, content: {
            editSheet
                .onAppear {
                    
                    if let s = movie.startDate {
                        startDate = s
                    }
                    
                    if let e = movie.endDate {
                        endDate = e
                    }
                }
                .onDisappear {
                    status = DBMovie.Status.getStatusByInt(movie.status)
                }
                .presentationDetents([.fraction(0.3)])
                .alert(isPresented: $isShowingBookmarkAlert, content: {
                    changeAlert
                })
        })
        
    }
    
    var changeAlert: Alert {
        Alert(title: Text("변경하시겠습니까?"),
              primaryButton: .default(Text("확인") , action: {
            let newMovie = DBMovie(movie: movie)
            newMovie.touchedTime = Date.now
            
            if let s = status {
                switch(s) {
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
                movie = newMovie
            }
            isShowingEditSheet = false
            dismiss()
        }),
              secondaryButton: .cancel(Text("취소"), action: {
            isShowingDeleteAlertSheet = false
        })
        )
    }
    
    
    var editSheet: some View {
        VStack {
            
            if status == .ing {
                DatePicker(selection: $startDate, displayedComponents: .date) {
                    Text("시작 날짜")
                        .font(.body02)
                }
                .padding()
            }
            
            else if status == .end {
                VStack(spacing: 20) {
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("시작 날짜")
                            .font(.body02)
                    }
                    
                    DatePicker("끝난 날짜", selection: $endDate, in: startDate...(Calendar.current.date(byAdding: .year, value: 1, to: startDate) ?? startDate), displayedComponents: .date)
                        .font(.body02)
                }
                .padding()
                .padding(.top, 30)
            }
            
            
            Button {
                isShowingBookmarkAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("저장")
                        .foregroundColor(Color.white)
                        .font(.body02)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
            }
            .foregroundColor(.white)
            .padding(.leading, 11)
            .padding(.trailing, 15)
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    MyMediaDetailView(myMediaService: MyMediaService(), movie: DBMovie(title: "태어난 김에 세계일주 3", MovieID: 0, runtime: 235, posterLink: nil, touchedTime: Date.now, releaseDate: "2023-03-21", overview: "모두 끝나버렸다 난 시작도 안해봤는데", status: 0, actors: ["정우성", "김유진"], director: "김유진", myRuntime: 0, startDate: nil, endDate: nil))
}
