//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation
import RealmSwift

final class MyMediaService: ObservableObject {
    @Published var myMovies: [DBMovie] = []
    @Published var filteredMovies: [DBMovie] = []
    
    @Published var myRunningTime: Int = -1
    
    private static var realm: Realm = try! Realm()
    
    private var recentStatus: Int = -1
    
    func addMovie(newMovie: DBMovie) {
        myMovies.append(newMovie)
        do {
            try MyMediaService.realm.write {
                MyMediaService.realm.add(newMovie)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        self.filterMovies(status: recentStatus)
    }
    
    func editMovie(oldMovie: DBMovie, newStatus: DBMovie.Status) {
        do {
            try MyMediaService.realm.write {
                oldMovie.touchedTime = Date.now
                oldMovie.status = newStatus.rawValue
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        self.fetchAllMovie()
    }
    
    func editMovie(oldMovie: DBMovie, newMovie: DBMovie) {
        do {
            try MyMediaService.realm.write {
                oldMovie.touchedTime = newMovie.touchedTime
                oldMovie.status = newMovie.status
                oldMovie.myRuntime = newMovie.myRuntime
                oldMovie.startDate = newMovie.startDate
                oldMovie.endDate = newMovie.endDate
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
        
        self.fetchAllMovie()
    }
    
    func delMovie(movie: DBMovie) {
        // FIXME: DELETE ERROR . . .
        do {
            try MyMediaService.realm.write {
                MyMediaService.realm.delete(movie)
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
        
        myMovies = []
        filteredMovies = []
        
        self.fetchAllMovie()
    }
    
    func fetchAllMovie() {
        myMovies = Array(MyMediaService.realm.objects(DBMovie.self))
        self.filterMovies(status: recentStatus)
    }
    
    func filterMovies(status: Int) {
        recentStatus = status
        
        if let _ = DBMovie.Status.getStatusByInt(status) {
            filteredMovies = myMovies.filter { movie in
                movie.status == status
            }
        }
        else {
            filteredMovies = myMovies
        }
    }
    
    func resetRunningTime(startDate: Date, endDate: Date) {
        if myMovies.isEmpty {
            myRunningTime = 0
            return
        }
        
        myRunningTime = 0
        for movie in myMovies {
            if let end = movie.endDate {
                if startDate...endDate ~= end {
                    myRunningTime += movie.myRuntime
                }
            }
        }
    }
}

