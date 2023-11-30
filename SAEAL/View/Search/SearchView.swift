//
//  SearchView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var myMediaService: MyMediaService
    
    @State private var searchText: String = "서울의 봄"
    @State private var movies: [TMDBService.SearchMovie] = []
    @State private var isShowingAlert: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if movies.isEmpty {
                Spacer()
            }
            
            HStack {
                TextField(text: $searchText) {
                    Text("어떤 영화를 기록하시겠어요?")
                        .font(.dotumMedium(size: 15))
                }
                .foregroundStyle(Color.color2)
                
                Button(action: {
                    Task {
                        if let m = await TMDBService.findMoviebyString(word: searchText) {
                            movies = m
                        }
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                        .foregroundStyle(Color.color2)
                })
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.color5)
            }
            
            
        }
        .padding()
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(movies, id:\.self) { movie in
                    NavigationLink {
                        SearchMovieDetailView(myMediaService: myMediaService, movie: movie)
                    } label: {
                        OneMovieCapsule(movie: DBMovie(title: movie.title, MovieID: movie.id, runtime: 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: -1, actors: [], director: "", myRuntime: 0, startDate: nil, endDate: nil))
                        
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
    }
    
}

#Preview {
    SearchView(myMediaService: MyMediaService())
}
