//
//  MyMediaDetailView.swift
//  SAEAL
//
//  Created by 김유진 on 11/20/23.
//

import SwiftUI

struct MyMediaDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var movie: DBMovie
    
    @StateObject private var myMediaDetailVM: MyMediaDetailViewModel = MyMediaDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                MovieDetailSubView(movie: movie)
                
                HStack(spacing: 30) {
                    ForEach(DBMovie.Status.allCases, id:\.self) { s in
                        Button {
                            myMediaDetailVM.openSheet(s: s)
                        } label: {
                            VStack {
                                Image(s.getStatusImageString())
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(s == myMediaDetailVM.status ? Color.black : Color.gray)
                                Text(s.statusString)
                                    .font(.body02)
                                    .foregroundStyle(s == myMediaDetailVM.status ? Color.black : Color.gray)
                            }
                        }
                        .buttonStyle(.plain)
                        .alert(isPresented: Binding<Bool>(
                            get: { myMediaDetailVM.isShowingBookmarkAlert },
                            set: { myMediaDetailVM.isShowingBookmarkAlert = $0}
                        ), content: {
                            changeAlert
                        })
                    }
                    
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
                myMediaDetailVM.setStatus(s: movie.status)
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .sheet(isPresented: Binding<Bool>(
                get: { myMediaDetailVM.isShowingEditSheet },
                set: { myMediaDetailVM.isShowingEditSheet = $0}
            ), content: {
                editSheet
                    .onAppear {
                        
                        if let s = movie.startDate {
                            myMediaDetailVM.startDate = s
                        }
                        
                        if let e = movie.endDate {
                            myMediaDetailVM.endDate = e
                        }
                    }
                    .onDisappear {
                        myMediaDetailVM.setStatus(s: movie.status)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .alert(isPresented: Binding<Bool>(
                        get: { myMediaDetailVM.isShowingBookmarkAlert },
                        set: { myMediaDetailVM.isShowingBookmarkAlert = $0}
                    ), content: {
                        changeAlert
                    })
            })
        }
        
    }
    
    var changeAlert: Alert {
        Alert(title: Text("변경하시겠습니까?"),
              primaryButton: .default(Text("확인") , action: {
            let newMovie = DBMovie(movie: movie)
            myMediaDetailVM.editMovie(oldMovie: movie, newMovie: newMovie)
            
            movie = newMovie
            dismiss()
        }),
              secondaryButton: .cancel(Text("취소"), action: {
            myMediaDetailVM.isShowingDeleteAlertSheet = false
        })
        )
    }
    
    
    var editSheet: some View {
        VStack {
            
            if myMediaDetailVM.status == .ing {
                DatePicker(selection: Binding<Date>(
                    get: { myMediaDetailVM.startDate },
                    set: { myMediaDetailVM.startDate = $0}
                ), displayedComponents: .date) {
                    Text("시작 날짜")
                        .font(.body02)
                }
                .padding()
            }
            
            else if myMediaDetailVM.status == .end {
                VStack(spacing: 20) {
                    DatePicker(selection: Binding<Date>(
                        get: { myMediaDetailVM.startDate },
                        set: { myMediaDetailVM.startDate = $0}
                    ), displayedComponents: .date) {
                        Text("시작 날짜")
                            .font(.body02)
                    }
                    .onChange(of: myMediaDetailVM.startDate, perform: { value in
                        myMediaDetailVM.endDate = myMediaDetailVM.startDate
                    })
                    
                    DatePicker("끝난 날짜", 
                               selection: Binding<Date>(
                                get: { myMediaDetailVM.endDate },
                                set: { myMediaDetailVM.endDate = $0}
                            ),
                               in: myMediaDetailVM.startDate..., displayedComponents: .date)
                        .font(.body02)
                }
                .padding()
                .padding(.top, 30)
            }
            
            
            Button {
                myMediaDetailVM.isShowingBookmarkAlert = true
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
    MyMediaDetailView(movie: DBMovie(title: "태어난 김에 세계일주 3", MovieID: 0, runtime: 235, posterLink: nil, touchedTime: Date.now, releaseDate: "2023-03-21", overview: "모두 끝나버렸다 난 시작도 안해봤는데", status: 0, actors: ["정우성", "김유진"], director: "김유진", myRuntime: 0, startDate: nil, endDate: nil))
}
