//
//  MovieDetailView.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchMovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var movie: SearchViewModel.SearchMovie
    @StateObject private var searchMovieDetailVM: SearchMovieDetailViewModel
    
    init(movie: SearchViewModel.SearchMovie) {
        self.movie = movie
        _searchMovieDetailVM = StateObject(wrappedValue: SearchMovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let detail = searchMovieDetailVM.movieDetail {
                    MovieDetailSubView(movie: DBMovie(title: searchMovieDetailVM.movie.title, MovieID: movie.id, runtime: detail.runtime, posterLink: searchMovieDetailVM.movie.posterPath, touchedTime: Date.now, releaseDate: searchMovieDetailVM.movie.releaseDate, overview: searchMovieDetailVM.movie.overview, status: -1, actors: searchMovieDetailVM.actors, director: searchMovieDetailVM.director, myRuntime: -1, startDate: searchMovieDetailVM.startDate, endDate: searchMovieDetailVM.endDate))
                }
                
                HStack(spacing: 30) {
                    ForEach(DBMovie.Status.allCases, id:\.self) { s in
                        Button {
                            searchMovieDetailVM.changeStatus(newStatus: s)
                        } label: {
                            VStack {
                                Image(s.getStatusImageString())
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(s == searchMovieDetailVM.status ? Color.black : Color.gray)
                                Text(s.statusString)
                                    .font(.body02)
                                    .foregroundStyle(s == searchMovieDetailVM.status ? Color.black : Color.gray)
                            }
                        }
                        .buttonStyle(.plain)
                        .onChange(of: searchMovieDetailVM.status, perform: { value in
                            if searchMovieDetailVM.status != .bookmark && s == searchMovieDetailVM.status {
                                searchMovieDetailVM.isShowingSaveSheet = true
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
                        Text("\(searchMovieDetailVM.movie.overview)")
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
                searchMovieDetailVM.getDetailAndCredit(movie: searchMovieDetailVM.movie)
            }
            .sheet(isPresented: Binding<Bool>(
                get: { searchMovieDetailVM.isShowingSaveSheet },
                set: { searchMovieDetailVM.isShowingSaveSheet = $0 }
            ), onDismiss: {
                searchMovieDetailVM.status = nil
            }, content: {
                saveSheet
                    .presentationDetents([.fraction(0.3)])
            })
            .alert(isPresented: Binding<Bool>(
                get: { searchMovieDetailVM.isShowingSaveAlert },
                set: { searchMovieDetailVM.isShowingSaveAlert = $0 }
            ), content: {
                Alert(title: Text("나의 필모그래피에 등록하시겠습니까?"),
                      primaryButton: .default(Text("등록") , action: {
                    searchMovieDetailVM.addMovie(newMovie: DBMovie(title: searchMovieDetailVM.movie.title, MovieID: searchMovieDetailVM.movie.id, runtime: searchMovieDetailVM.movieDetail?.runtime ?? 0, posterLink: searchMovieDetailVM.movie.posterPath, touchedTime: Date.now, releaseDate: searchMovieDetailVM.movie.releaseDate, overview: searchMovieDetailVM.movie.overview, status: DBMovie.Status.bookmark.rawValue, actors: searchMovieDetailVM.actors, director: searchMovieDetailVM.director, myRuntime: 0, startDate: nil, endDate: nil))
                    dismiss()
                }),
                      secondaryButton: .destructive(Text("취소"), action: { searchMovieDetailVM.status = nil })
                )
            })
        }
    }
    
    var saveSheet: some View {
        VStack {
            if searchMovieDetailVM.status == .ing {
                DatePicker(selection: Binding<Date>(
                    get: { searchMovieDetailVM.startDate },
                    set: { searchMovieDetailVM.startDate = $0 }
                ), displayedComponents: .date) {
                    Text("시작 날짜")
                        .font(.body02)
                }
                .padding()
            }
            
            else if searchMovieDetailVM.status == .end {
                VStack(spacing: 20) {
                    DatePicker(selection: Binding<Date>(
                        get: { searchMovieDetailVM.startDate },
                        set: { searchMovieDetailVM.startDate = $0 }
                    ), displayedComponents: .date) {
                        Text("시작 날짜")
                            .font(.body02)
                    }
                    .onChange(of: searchMovieDetailVM.startDate, perform: { value in
                        searchMovieDetailVM.endDate = searchMovieDetailVM.startDate
                    })
                    
                    DatePicker("끝난 날짜", selection: Binding<Date>(
                        get: { searchMovieDetailVM.endDate },
                        set: { searchMovieDetailVM.endDate = $0 }
                    ), in: searchMovieDetailVM.startDate..., displayedComponents: .date)
                        .font(.body02)
                }
                .padding()
                .padding(.top, 30)
            }
            
            Button {
                // TODO: 이미 나의 필모그래피에 있는 경우
                // 이미 나의 필모그래피에 존재합니다. 2회차를 감상하시겠습니까?
                searchMovieDetailVM.isShowingSaveAlert = true
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
            .alert(isPresented: Binding<Bool>(
                get: { searchMovieDetailVM.isShowingSaveAlert },
                set: { searchMovieDetailVM.isShowingSaveAlert = $0 }
            ), content: {
                Alert(title: Text("나의 필모그래피에 등록하시겠습니까?"),
                      primaryButton: .default(Text("등록") , action: {
                    searchMovieDetailVM.registerMovie(movie: movie)
                    searchMovieDetailVM.isShowingSaveSheet = false
                    dismiss()
                }),
                      secondaryButton: .cancel(Text("취소"), action: {
                    searchMovieDetailVM.isShowingSaveSheet = false
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
