//
//  ContentView.swift
//  RunningTime
//
//  Created by 김유진 on 11/8/23.
//

import SwiftUI


struct ContentView: View {
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
                        if let m = await findMoviebyString(word: searchText) {
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
    
    func findMoviebyString(word: String) async -> [Movie]? {
        
        let urlString = "https://api.themoviedb.org/3/search/movie"
        let URL = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: URL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") //header
        urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNjAwMjczYWIyMDIxNWQ0Y2RlMjMwM2EwYTJjOTQxYyIsInN1YiI6IjY1NGI3MDMyMjg2NmZhMDEzOGE5MmM1YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.C3f2Etm1_J7vbWP_OBWyDXZHr_a4StvemRthI4rAAsE", forHTTPHeaderField: "Authorization") //header
        urlRequest.httpMethod = "GET"
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems =
        [
            URLQueryItem(name: "query", value: word),
            URLQueryItem(name: "language", value: "ko-KR"),
        ]
        urlRequest.url = urlComponent?.url
        
//        print(urlRequest)
        
        var data: Data
        var dataDecoded: SearchResult
        
        let session = URLSession.shared
        
        do {
            (data, _) = try await session.data(for: urlRequest)
            dataDecoded = try JSONDecoder().decode(SearchResult.self, from: data)
            
            return dataDecoded.results
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
    
    
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
