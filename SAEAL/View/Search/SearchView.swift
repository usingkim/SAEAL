//
//  SearchView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var myMediaService: MyMediaService
    
    @State private var searchText: String = ""
    @State private var movies: [TMDBService.SearchMovie] = []
    @State private var isShowingAlert: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            
            HStack {
                TextField(text: $searchText) {
                    Text("어떤 영화를 기록하시겠어요?")
                        .font(.title05)
                }
                .font(.title05)
                
                Button(action: {
                    Task {
                        if let m = await TMDBService.findMoviebyString(word: searchText) {
                            movies = m
                        }
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            
            if movies.isEmpty {
                Spacer()
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        
        
        List(movies, id:\.self) { movie in
            HStack {
                NavigationLink {
                    SearchMovieDetailView(myMediaService: myMediaService, movie: movie)
                } label: {
                    OneMovieCapsule(movie: DBMovie(title: movie.title, MovieID: movie.id, runtime: 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: -1, actors: [], director: "", myRuntime: 0, startDate: nil, endDate: nil))
                }
                
//                Button {
//                    print("add")
//                } label: {
//                    Image(.addButton)
//                }
//                .buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        
        .padding()
    }
    
}

#Preview {
    SearchView(myMediaService: MyMediaService())
}
