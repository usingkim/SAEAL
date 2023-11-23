//
//  TMDBService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

struct TMDBService {
    
    /// header 추가
    private static func makeURLRequest(url: URL)->URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(APIConstant.accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    /// 검색을 통해 Movie 리스트를 리턴
    static func findMoviebyString(word: String) async -> [SearchMovie]? {
        
        let urlString = APIConstant.baseURL + "search/movie"
        let URL = URL(string: urlString)!
        
        var urlRequest = makeURLRequest(url: URL)
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems =
        [
            URLQueryItem(name: "query", value: word),
            URLQueryItem(name: "language", value: "ko-KR"),
        ]
        urlRequest.url = urlComponent?.url
        
        // Data 가져오기
        var data: Data
        
        let session = URLSession.shared
        
        do {
            (data, _) = try await session.data(for: urlRequest)
            let dataDecoded = try JSONDecoder().decode(SearchViewModel.self, from: data)
            
            return dataDecoded.results
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
    
    /// id 값을 통해 해당 영화의 디테일 값을 리턴
    static func getMovieDetailByID(id: Int) async -> MovieDetail?  {
        let urlString = APIConstant.baseURL + "movie/\(id)"
        let URL = URL(string: urlString)!
        
        var urlRequest = makeURLRequest(url: URL)
        
        
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
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
    
}

extension TMDBService {
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
    
    struct SearchViewModel: Codable {
        let page: Int
        let results: [SearchMovie]
        let totalPages, totalResults: Int

        enum CodingKeys: String, CodingKey {
            case page, results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
    
    struct MovieDetail: Codable {
        var title: String
        var original_language: String
        var original_title: String
        var overview: String
        var runtime: Int
        var status: String
    }


}
