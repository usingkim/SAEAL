//
//  SearchMovieDetailViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class SearchMovieDetailViewModel: ObservableObject {
    
    @Published var movieDetail: MovieDetail?
    @Published var movieCredit: MovieCredit?
    @Published var director: String = ""
    @Published var actors: [String] = []
    @Published var isShowingSaveSheet: Bool = false
    @Published var isShowingSaveAlert: Bool = false
    @Published var status: DBMovie.Status? = nil
    @Published var watchedTime: Double = 0
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    
    func changeStatus(newStatus: DBMovie.Status) {
        if status == newStatus {
            status = nil
        }
        else {
            status = newStatus
        }
        if status == .bookmark {
            isShowingSaveAlert = true
        }
    }
    
    func getDetailAndCredit(movie: SearchViewModel.SearchMovie) {
        Task {
            if let detail = await getMovieDetailByID(id: movie.id) {
                movieDetail = detail
            }
            else {
                print("영화 정보가 없습니다.")
            }
            
            if let credit = await getMovieCreditByID(id: movie.id) {
                movieCredit = credit
                var numOfActor = 0
                for actor in credit.cast {
                    actors.append(actor.name)
                    numOfActor += 1
                    if numOfActor == 3 {
                        break
                    }
                }
                if let idx = movieCredit?.crew.firstIndex(where: { $0.job == "Directing" || $0.job ==  "Director" }) {
                    director = credit.crew[idx].name
                }
            }
            else {
                print("Credit 정보가 없습니다.")
            }
            
        }
    }
    
    func addMovie(newMovie: DBMovie) {
        do {
            try realm.write {
                realm.add(newMovie)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
    }
    
    func registerMovie(movie: SearchViewModel.SearchMovie) {
        switch(status) {
        case .bookmark:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.bookmark.rawValue, actors: actors, director: director, myRuntime: 0, startDate: nil, endDate: nil))
        case .ing:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.ing.rawValue, actors: actors, director: director, myRuntime: Int(watchedTime), startDate: startDate, endDate: nil))
        case .end:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.end.rawValue, actors: actors, director: director, myRuntime: movieDetail?.runtime ?? 0, startDate: startDate, endDate: endDate))
        case .none:
            print()
        }
    }
    
    func makeURLRequest(url: URL)->URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(APIConstant.accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    
    /// id 값을 통해 해당 영화의 디테일 값을 리턴
    func getMovieDetailByID(id: Int) async -> MovieDetail?  {
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
    
    /// id 값을 통해 해당 영화의 Credit 값을 리턴
    func getMovieCreditByID(id: Int) async -> MovieCredit?  {
        let urlString = APIConstant.baseURL + "movie/\(id)/credits"
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
            
            let dataDecoded = try JSONDecoder().decode(MovieCredit.self, from: data)
            return dataDecoded
        }
        catch {
            print("Can't Find or Decode Data")
        }
        
        return nil
    }
}

extension SearchMovieDetailViewModel {
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
    
    struct MovieDetail: Codable {
        var title: String
        var original_language: String
        var original_title: String
        var overview: String
        var runtime: Int
        var status: String
    }
    
    struct MovieCredit: Codable {
        let id: Int
        let cast, crew: [Cast]
    }

    struct Cast: Codable {
        let adult: Bool
        let gender, id: Int
        let knownForDepartment, name, originalName: String
        let popularity: Double
        let profilePath: String?
        let castID: Int?
        let character: String?
        let creditID: String
        let order: Int?
        let department, job: String?

        enum CodingKeys: String, CodingKey {
            case adult, gender, id
            case knownForDepartment = "known_for_department"
            case name
            case originalName = "original_name"
            case popularity
            case profilePath = "profile_path"
            case castID = "cast_id"
            case character
            case creditID = "credit_id"
            case order, department, job
        }
    }

}
