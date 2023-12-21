//
//  MyMediaViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation
import RealmSwift

final class MyMediaViewModel: ObservableObject {
    @Published var filteredMovies: [MyMovie] = []
    @Published var status: DBMovie.Status?
    @Published var isShowingDeleteAlert: Bool = false
    
    private var Movies: [DBMovie] = []
    private var recentStatus: Int = -1
    
    func fetchAllMovie() {
        Movies = Array(realm.objects(DBMovie.self))
        Movies.sort { $0.touchedTime > $1.touchedTime }
        self.filterMovies(status: recentStatus)
    }
    
    func filterMovies(status: Int) {
        var filteredDBMovies: [DBMovie] = []
        recentStatus = status
        
        if let _ = DBMovie.Status.getStatusByInt(status) {
            filteredDBMovies = Movies.filter { movie in
                movie.status == status
            }
        }
        else {
            filteredDBMovies = Movies
        }
        
        filteredMovies = []
        for movie in filteredDBMovies {
            filteredMovies.append(MyMovie(movie: movie))
        }
    }
    
    func delMovie(movie: DBMovie) {
        do {
            if let forDelete = realm.object(ofType: DBMovie.self, forPrimaryKey: movie.id) {
                try realm.write {
                    realm.delete(forDelete)
                }
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
        
        self.fetchAllMovie()
    }
}

extension MyMediaViewModel {
    struct MyMovie: Identifiable, Codable {
        var id: String
        
        var title: String
        var MovieID: Int
        var runtime: Int
        var posterLink: String?
        var touchedTime: Date
        var status: Int
        var releaseDate: String
        var overview: String
        var actors: [String]
        var director: String
        
        // 나의 영화 관련 정보
        var myRuntime: Int
        var startDate: Date?
        var endDate: Date?
        
        var score: Int = 3
        var review: [String] = []
        
        init(id: String, title: String, MovieID: Int, runtime: Int, posterLink: String? = nil, touchedTime: Date, status: Int, releaseDate: String, overview: String, actors: [String], director: String, myRuntime: Int, startDate: Date? = nil, endDate: Date? = nil, score: Int, review: [String]) {
            self.id = id
            self.title = title
            self.MovieID = MovieID
            self.runtime = runtime
            self.posterLink = posterLink
            self.touchedTime = touchedTime
            self.status = status
            self.releaseDate = releaseDate
            self.overview = overview
            self.actors = actors
            self.director = director
            self.myRuntime = myRuntime
            self.startDate = startDate
            self.endDate = endDate
            self.score = score
            self.review = review
        }
        
        init(movie: DBMovie) {
            self.id = movie.id
            self.title = movie.title
            self.MovieID = movie.MovieID
            self.runtime = movie.runtime
            self.posterLink = movie.posterLink
            self.touchedTime = movie.touchedTime
            self.status = movie.status
            self.releaseDate = movie.releaseDate
            self.overview = movie.overview
            self.actors = Array(movie.actors)
            self.director = movie.director
            self.myRuntime = movie.myRuntime
            self.startDate = movie.startDate
            self.endDate = movie.endDate
            self.score = movie.score
            self.review = Array(movie.review)
        }
        
        func toDBMovie()->DBMovie {
            return DBMovie(movie: self)
        }
    }

}
