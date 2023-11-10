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
    static func findMoviebyString(word: String) async -> [Movie]? {
        
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
            let dataDecoded = try JSONDecoder().decode(SearchResult.self, from: data)
            
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
