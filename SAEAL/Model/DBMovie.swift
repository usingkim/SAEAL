//
//  Movie.swift
//  SAEAL
//
//  Created by 김유진 on 11/13/23.
//

import Foundation
import RealmSwift

final class DBMovie: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    @Persisted var MovieID: Int
    @Persisted var runtime: Int
    @Persisted var posterLink: String?
    @Persisted var touchedTime: Date
    @Persisted var status: Int
    
    // 나의 영화 관련 정보
    @Persisted var myRuntime: Int
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    
    override init() {
        super.init()
        self.id = UUID().uuidString
        self.title = ""
        self.MovieID = 0
        self.runtime = 0
        self.posterLink = nil
        self.touchedTime = Date.now
        self.status = 0
        self.myRuntime = 0
        self.startDate = Date.now
        self.endDate = Date.now
    }
    
    init(title: String, MovieID: Int, runtime: Int, posterLink: String?, touchedTime: Date, status: Int, myRuntime: Int, startDate: Date?, endDate: Date?) {
        super.init()
        self.id = UUID().uuidString
        self.title = title
        self.MovieID = MovieID
        self.runtime = runtime
        self.posterLink = posterLink
        self.touchedTime = touchedTime
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
        self.status = movie.status
        self.myRuntime = movie.myRuntime
        self.startDate = movie.startDate
        self.endDate = movie.endDate
    }
    
}
