//
//  MovieDetailView.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct MovieDetailView: View {
    @State var movie: Movie
    @State private var movieDetail: MovieDetail?
    
    var body: some View {
        VStack {
            if let detail = movieDetail {
                Text(detail.title)
                Text("\(detail.runtime)")
            }
        }
        .onAppear {
            Task {
                if let detail = await getMovieDetailByID(id: movie.id) {
                    movieDetail = detail
                }
                else {
                    print("러닝 타임 정보가 없습니다.")
                }
            }
        }
    }
    
    
    func getMovieDetailByID(id: Int) async -> MovieDetail?  {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)"
        let URL = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: URL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") //header
        urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNjAwMjczYWIyMDIxNWQ0Y2RlMjMwM2EwYTJjOTQxYyIsInN1YiI6IjY1NGI3MDMyMjg2NmZhMDEzOGE5MmM1YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.C3f2Etm1_J7vbWP_OBWyDXZHr_a4StvemRthI4rAAsE", forHTTPHeaderField: "Authorization") //header
        urlRequest.httpMethod = "GET"
        
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems =
        [
            URLQueryItem(name: "language", value: "ko-KR"),
        ]
        urlRequest.url = urlComponent?.url
        
        
        var data: Data
        
        let session = URLSession.shared
        
        do {
            (data, _) = try await session.data(for: urlRequest)
            
            let dataDecoded = try JSONDecoder().decode(MovieDetail.self, from: data)
            
            return dataDecoded
            
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    return json["runtime"] as? Int
//                }
            
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
    
}
//
//#Preview {
//    MovieDetailView(movie: Movie(adult: <#T##Bool#>, genreIDS: <#T##[Int]#>, id: <#T##Int#>, originalLanguage: <#T##OriginalLanguage#>, originalTitle: <#T##String#>, overview: <#T##String#>, popularity: <#T##Double#>, releaseDate: <#T##String#>, title: <#T##String#>, video: <#T##Bool#>, voteAverage: <#T##Double#>, voteCount: <#T##Int#>))
//}
