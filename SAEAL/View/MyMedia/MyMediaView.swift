//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI
import Kingfisher

struct MyMediaView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var myMediaService: MyMediaService
    @State private var status: Status?
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    status = nil
                    myMediaService.filterMovies(status: status?.rawValue ?? -1)
                }, label: {
                    Text("전체")
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .bookmark
                    myMediaService.filterMovies(status: Status.bookmark.rawValue)
                }, label: {
                    Text(Status.bookmark.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .ing
                    myMediaService.filterMovies(status: Status.ing.rawValue)
                }, label: {
                    Text(Status.ing.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .end
                    myMediaService.filterMovies(status: Status.end.rawValue)
                }, label: {
                    Text(Status.end.statusString)
                })
                .buttonStyle(.plain)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(myMediaService.filteredMovies) { movie in
                        NavigationLink {
                            MyMediaDetailView(myMediaService: MyMediaService(), movie: movie)
                        } label: {
                            VStack {
                                if let poster = movie.posterLink {
                                    KFImage(URL(string: APIConstant.imageURL + poster))
                                        .retry(maxCount: 3, interval: .seconds(5))
                                        .resizable()
                                        .frame(width: 120, height: 150)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                    Text(movie.title)
                                        .lineLimit(1)
                                }
                                else {
                                    Spacer()
                                    Text(movie.title)
                                }
                            }
                            .padding()
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct EditSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var myMediaService: MyMediaService
    
    @State var movie: DBMovie
    @Binding var isShowingEditSheet: Bool
    
    @State private var status: Status = .bookmark
    
    @State private var watchedTime: Double = 0
    
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Status.allCases, id:\.self) { s in
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
                let newMovie = DBMovie(movie: movie)
                newMovie.touchedTime = Date.now
                
                switch(status) {
                case .bookmark:
                    newMovie.status = Status.bookmark.rawValue
                    newMovie.myRuntime = 0
                    newMovie.startDate = nil
                    newMovie.endDate = nil
                case .ing:
                    newMovie.status = Status.ing.rawValue
                    newMovie.myRuntime = Int(watchedTime)
                    newMovie.startDate = startDate
                    newMovie.endDate = nil
                case .end:
                    newMovie.status = Status.end.rawValue
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
    MyMediaView(myMediaService: MyMediaService())
}
