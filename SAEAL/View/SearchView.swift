//
//  SearchView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = "iron man"
    @State private var movies: [Movie] = []
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                TextField(text: $searchText) {
                    Text("hello")
                }
                Button(action: {
                    Task {
                        if let m = await TMDBService.findMoviebyString(word: searchText) {
                            movies = m
                        }
                    }
                    
                    
                }, label: {
                    Text("Button")
                })
            }
            .padding()
        }
        
        List(movies, id:\.self) { movie in
            NavigationLink {
                MovieDetailView(movie: movie)
            } label: {
                Text("\(movie.title)")
            }

        }
    }
    
}

#Preview {
    SearchView()
}
