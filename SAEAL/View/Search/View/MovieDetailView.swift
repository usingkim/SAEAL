//
//  MovieDetailView.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var myMedias: MyMediaService
    
    @State var movie: Movie
    @State private var movieDetail: MovieDetail?
    @State private var isShowingSaveSheet: Bool = false
    @State private var status: Status = .bookmark
    
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
                    print("러닝 타임 정보가 없습니다.")
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
                })
            }
        })
    }
    
    var saveSheet: some View {
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
            
            Button {
                myMedias.addMedia(newMedia: Media(type: .movie, title: movie.title, MovieID: movie.id, runtime: [movieDetail?.runtime ?? 0], posterLink: movie.posterPath, status: status))
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
