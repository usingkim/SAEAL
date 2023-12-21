//
//  Movie.swift
//  SAEAL
//
//  Created by 김유진 on 11/13/23.
//

import RealmSwift
import Foundation

final class DBMovie: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    @Persisted var MovieID: Int
    @Persisted var runtime: Int
    @Persisted var posterLink: String?
    @Persisted var touchedTime: Date
    @Persisted var status: Int
    @Persisted var releaseDate: String
    @Persisted var overview: String
    @Persisted var actors: List<String>
    @Persisted var director: String
    
    // 나의 영화 관련 정보
    @Persisted var myRuntime: Int
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    
    @Persisted var score: Int = 3
    @Persisted var review: List<String> = List<String>()
    
    override init() {
        super.init()
        self.id = UUID().uuidString
        self.title = ""
        self.MovieID = 0
        self.runtime = 0
        self.posterLink = nil
        self.touchedTime = Date.now
        self.overview = ""
        self.actors = List<String>()
        self.director = ""
        self.status = 0
        self.myRuntime = 0
        self.startDate = Date.now
        self.endDate = Date.now
    }
    
    init(title: String, MovieID: Int, runtime: Int, posterLink: String?, touchedTime: Date, releaseDate: String, overview: String, status: Int, actors: [String], director: String, myRuntime: Int, startDate: Date?, endDate: Date?) {
        super.init()
        self.id = UUID().uuidString
        self.title = title
        self.MovieID = MovieID
        self.runtime = runtime
        self.posterLink = posterLink
        self.touchedTime = touchedTime
        self.releaseDate = releaseDate
        self.overview = overview
        
        let actorList = List<String>()
        actorList.append(objectsIn: actors)
        self.actors = actorList
        self.director = director
        
        self.status = status
        self.myRuntime = myRuntime
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(movie: DBMovie) {
        super.init()
        self.id = movie.id
        self.title = movie.title
        self.MovieID = movie.MovieID
        self.runtime = movie.runtime
        self.posterLink = movie.posterLink
        self.touchedTime = movie.touchedTime
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.actors = movie.actors
        self.director = movie.director
        self.status = movie.status
        self.myRuntime = movie.myRuntime
        self.startDate = movie.startDate
        self.endDate = movie.endDate
    }
    
    init(movie: MyMediaViewModel.MyMovie) {
        super.init()
        self.id = movie.id
        self.title = movie.title
        self.MovieID = movie.MovieID
        self.runtime = movie.runtime
        self.posterLink = movie.posterLink
        self.touchedTime = movie.touchedTime
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.actors = List<String>()
        self.actors.append(objectsIn: movie.actors)
        self.director = movie.director
        self.status = movie.status
        self.myRuntime = movie.myRuntime
        self.startDate = movie.startDate
        self.endDate = movie.endDate
    }
    
    enum Status: Int, CaseIterable {
        case bookmark
        case ing
        case end
        
        var statusString: String {
            switch(self){
            case .bookmark:
                return "보고싶어요"
            case .ing:
                return "보는 중"
            case .end:
                return "봤어요"
            }
        }
        
        static func getStatusByInt(_ statusNum: Int)-> Status? {
            switch statusNum {
            case 0:
                return .bookmark
            case 1:
                return .ing
            case 2:
                return .end
            default:
                return nil
            }
        }
        
        func getStatusImageString()->String {
            switch self {
            case .bookmark:
                return "bookmark"
            case .ing:
                return "watching"
            case .end:
                return "filming"
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
