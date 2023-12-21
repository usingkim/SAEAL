//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation
import RealmSwift

var realm: Realm = try! Realm()

final class MyMediaService: ObservableObject {
    @Published var Movies: [DBMovie] = []
    @Published var filteredMovies: [MyMediaViewModel.MyMovie] = []
    
    @Published var myRunningTime: Int = -1
    @Published var monthlyRunningTime = (1...12).map { [$0, 0] }
    
    
    
    private var recentStatus: Int = -1
    
    func addMovie(newMovie: DBMovie) {
        Movies.append(newMovie)
        do {
            try realm.write {
                realm.add(newMovie)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        self.fetchAllMovie()
    }
    
    func editMovie(oldMovie: DBMovie, newStatus: DBMovie.Status) {
        let newMovie = oldMovie
        newMovie.status = newStatus.rawValue
        newMovie.touchedTime = Date.now
        
        do {
            try realm.write {
                realm.add(newMovie, update: .all)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        self.fetchAllMovie()
    }
    
    func editMovie(oldMovie: DBMovie, newMovie: DBMovie) {
        
        let movie = oldMovie
        movie.touchedTime = newMovie.touchedTime
        movie.status = newMovie.status
        movie.myRuntime = newMovie.myRuntime
        movie.startDate = newMovie.startDate
        movie.endDate = newMovie.endDate
        
        do {
            try realm.write {
                realm.add(movie, update: .all)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        
        self.fetchAllMovie()
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
    
    func delAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
        
        self.fetchAllMovie()
    }
    
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
            filteredMovies.append(MyMediaViewModel.MyMovie(movie: movie))
        }
    }
    
    func resetRunningTime(startDate: Date, endDate: Date) {
        if Movies.isEmpty {
            myRunningTime = 0
            monthlyRunningTime = (1...12).map { [$0, 0] }
            return
        }
        
        myRunningTime = 0
        monthlyRunningTime = (1...12).map { [$0, 0] }
        for movie in Movies {
            if let end = movie.endDate {
                if startDate...endDate ~= end {
                    myRunningTime += movie.myRuntime
                    if let month = Calendar.current.dateComponents([.month], from: end).month {
                        monthlyRunningTime[month - 1][1] += movie.myRuntime
                    }
                }
            }
        }
    }
    
    func writeReview(movie: DBMovie, score: Int, review: String) {
        do {
            try realm.write {
                movie.score = score
//                movie.review = review
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        self.fetchAllMovie()
    }
    
}

