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
    @State private var isShowingSaveAlert: Bool = false
    @State private var status: DBMovie.Status? = nil
    @State private var watchedTime: Double = 0
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    var body: some View {
        VStack {
            if let detail = movieDetail {
                MovieDetailSubView(movie: DBMovie(title: movie.title, MovieID: movie.id, runtime: detail.runtime, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: -1, actors: actors, director: director, myRuntime: -1, startDate: startDate, endDate: endDate))
            }
            
            HStack {
                ForEach(DBMovie.Status.allCases, id:\.self) { s in
                    Button {
                        if status == s {
                            status = nil
                        }
                        else {
                            status = s
                        }
                        if status == .bookmark {
                            isShowingSaveAlert = true
                        }
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
                    .onChange(of: status, perform: { value in
                        if status != .bookmark && s == status {
                            isShowingSaveSheet = true
                        }
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
        .padding(.leading, 16)
        .padding(.trailing, 16)
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
        .sheet(isPresented: $isShowingSaveSheet, onDismiss: {
            status = nil
        }, content: {
            saveSheet
                .presentationDetents([.fraction(0.3)])
        })
        .alert(isPresented: $isShowingSaveAlert, content: {
            Alert(title: Text("나의 필모그래피에 등록하시겠습니까?"),
                  primaryButton: .cancel(Text("등록") , action: {
                myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.bookmark.rawValue, actors: actors, director: director, myRuntime: 0, startDate: nil, endDate: nil))
                dismiss()
            }),
                  secondaryButton: .destructive(Text("취소"), action: { status = nil })
            )
        })
    }
    
    var saveSheet: some View {
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
                // TODO: 이미 나의 필모그래피에 있는 경우
                // 이미 나의 필모그래피에 존재합니다. 2회차를 감상하시겠습니까?
                isShowingSaveAlert = true
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
            .alert(isPresented: $isShowingSaveAlert, content: {
                Alert(title: Text("나의 필모그래피에 등록하시겠습니까?"),
                      primaryButton: .default(Text("등록") , action: {
                    switch(status) {
                    case .bookmark:
                        myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.bookmark.rawValue, actors: actors, director: director, myRuntime: 0, startDate: nil, endDate: nil))
                    case .ing:
                        myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.ing.rawValue, actors: actors, director: director, myRuntime: Int(watchedTime), startDate: startDate, endDate: nil))
                    case .end:
                        myMediaService.addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.end.rawValue, actors: actors, director: director, myRuntime: movieDetail?.runtime ?? 0, startDate: startDate, endDate: endDate))
                    case .none:
                        print()
                    }
                    isShowingSaveSheet = false
                    dismiss()
                }),
                      secondaryButton: .cancel(Text("취소"), action: {
                    isShowingSaveSheet = false
                })
                )
            })
        }
    }
}

                        

//
//#Preview {
//    MovieDetailView(movie: Movie(adult: <#T##Bool#>, genreIDS: <#T##[Int]#>, id: <#T##Int#>, originalLanguage: <#T##OriginalLanguage#>, originalTitle: <#T##String#>, overview: <#T##String#>, popularity: <#T##Double#>, releaseDate: <#T##String#>, title: <#T##String#>, video: <#T##Bool#>, voteAverage: <#T##Double#>, voteCount: <#T##Int#>))
//}
