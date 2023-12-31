//
//  SearchViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var movies: [SearchMovie] = []
    @Published var isShowingAlert: Bool = false
    @Published var isSearched: Bool = false
    
    func search() {
        Task {
            if let m = await findMoviebyString(word: searchText) {
                movies = m
            }
        }
        isSearched = true
    }
    
    func makeURLRequest(url: URL)->URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(APIConstant.accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    
    /// 검색을 통해 Movie 리스트를 리턴
    func findMoviebyString(word: String) async -> [SearchMovie]? {
        
        let urlString = APIConstant.baseURL + "search/movie"
        let URL = URL(string: urlString)!
        
        var urlRequest = makeURLRequest(url: URL)
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems =
        [
            URLQueryItem(name: "query", value: word),
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "include_adult", value: "false"),
        ]
        urlRequest.url = urlComponent?.url
        
        // Data 가져오기
        var data: Data
        
        let session = URLSession.shared
        
        do {
            (data, _) = try await session.data(for: urlRequest)
            let dataDecoded = try JSONDecoder().decode(SearchMovies.self, from: data)
            return dataDecoded.results
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
    
}

extension SearchViewModel {
    
    struct SearchMovie: Codable, Hashable {
        let adult: Bool
        let backdropPath: String?
        let genreIDS: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle, overview: String
        let popularity: Double
        let posterPath: String?
        let releaseDate, title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
    
    
    struct SearchMovies: Codable {
        let page: Int
        let results: [SearchMovie]
        let totalPages, totalResults: Int

        enum CodingKeys: String, CodingKey {
            case page, results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
}
