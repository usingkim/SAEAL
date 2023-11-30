//
//  MovieDetailView.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchMovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var myMediaService: MyMediaService
    
    @State var movie: TMDBService.SearchMovie
    @State private var movieDetail: TMDBService.MovieDetail?
    @State private var movieCredit: TMDBService.MovieCredit?
    @State private var director: String = ""
    @State private var actors: [String] = []
    @State private var isShowingSaveSheet: Bool = false
    @State private var status: DBMovie.Status = .bookmark
    @State private var watchedTime: Double = 0
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    var body: some View {
        VStack {
            if let detail = movieDetail {
                Text(detail.title)
                Text("\(detail.runtime)")
            }
        }
        .onAppear {
            Task {
                if let detail = await TMDBService.getMovieDetailByID(id: movie.id) {
                    movieDetail = detail
                }
                else {
                    print("영화 정보가 없습니다.")
                }
                
                if let credit = await TMDBService.getMovieCreditByID(id: movie.id) {
                    movieCredit = credit
                    var numOfActor = 0
                    for actor in credit.cast {
                        actors.append(actor.name)
                        numOfActor += 1
                        if numOfActor == 3 {
                            break
                        }
                    }
                    if let idx = movieCredit?.crew.firstIndex(where: { $0.job == "Directing" || $0.job ==  "Director" }) {
                        director = credit.crew[idx].name
                    }
                }
                else {
                    print("Credit 정보가 없습니다.")
                }
                
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isShowingSaveSheet = true
                }, label: {
                    Text("저장")
                })
                .sheet(isPresented: $isShowingSaveSheet, content: {
                    saveSheet
                        .presentationDetents([.medium])
                })
            }
        })
    }
    
    var saveSheet: some View {
        VStack {
            HStack {
                ForEach(DBMovie.Status.allCases, id:\.self) { s in
                    Button {
                        status = s
                    } label: {
                        Text(s.statusString)
                    }
                    .buttonStyle(.plain)
                    .background(status == s ? .red : .blue)
                }
            }
            
            Text("\(status.statusString)")
            
            if status == .ing {
                HStack {
                    Text("0")
                    Slider(value: $watchedTime, in: 0...Double(movieDetail?.runtime ?? 0), step: 1)
                        
                    Text("\(movieDetail?.runtime ?? 0)")
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
                switch(status) {
                case .bookmark:
                    myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: status.rawValue, actors: actors, director: director, myRuntime: 0, startDate: nil, endDate: nil))
                case .ing:
                    myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: status.rawValue, actors: actors, director: director, myRuntime: Int(watchedTime), startDate: startDate, endDate: nil))
                case .end:
                    myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: status.rawValue, actors: actors, director: director, myRuntime: movieDetail?.runtime ?? 0, startDate: startDate, endDate: endDate))
                }
                isShowingSaveSheet = false
                dismiss()
            } label: {
                Text("저장")
            }
        }
    }
}

                        

//
//#Preview {
//    MovieDetailView(movie: Movie(adult: <#T##Bool#>, genreIDS: <#T##[Int]#>, id: <#T##Int#>, originalLanguage: <#T##OriginalLanguage#>, originalTitle: <#T##String#>, overview: <#T##String#>, popularity: <#T##Double#>, releaseDate: <#T##String#>, title: <#T##String#>, video: <#T##Bool#>, voteAverage: <#T##Double#>, voteCount: <#T##Int#>))
//}
