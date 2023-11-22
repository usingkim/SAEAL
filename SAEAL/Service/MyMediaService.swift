//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation
import RealmSwift

final class MyMediaService: ObservableObject {
    @Published var myMovies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    
    @Published var myRunningTime: Int = -1
    
    private var recentStatus: Int = -1
    
    private static var realm: Realm = try! Realm()
    
    
    func addMovie(newMovie: Movie) {
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
        resetRunningTime()
    }
    
    func editMovie(oldMovie: Movie, newStatus: Status) {
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
    
    func editMovie(oldMovie: Movie, newMovie: Movie) {
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
    
    func delMovie(movie: Movie) {
        myMovies = []
        filteredMovies = []
        
        do {
            guard let movieToDelete = MyMediaService.realm.object(ofType: Movie.self, forPrimaryKey: movie.id) else {
                return
            }
            
            try MyMediaService.realm.write {
                MyMediaService.realm.delete(movieToDelete)
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
        
        self.fetchAllMovie()
    }
    
    func fetchAllMovie() {
        myMovies = Array(MyMediaService.realm.objects(Movie.self))
        self.filterMovies(status: recentStatus)
        resetRunningTime()
    }
    
    func filterMovies(status: Int) {
        recentStatus = status
        
        if let _ = Status.getStatusByInt(status) {
            filteredMovies = myMovies.filter { movie in
                movie.status == status
            }
        }
        else {
            filteredMovies = myMovies
        }
    }
    
    func resetRunningTime() {
        if myMovies.isEmpty {
            myRunningTime = 0
            return
        }
        
        myRunningTime = 0
        for movie in myMovies {
            myRunningTime += movie.myRuntime
        }
    }
}


//static func addMovie(_ movie: Movie) {
//    do {
//        try realm.write {
//            realm.add(movie)
//        }
//    }
//    catch {
//        print("WRITE ERROR!!!")
//    }
//}
//
//static func findAll() -> Results<Movie> {
//    return realm.objects(Movie.self)
//}
//
//static func editMovie(movie: Movie, newStatus: Status) {
//    do {
//        try realm.write {
//            movie.status = newStatus.rawValue
//        }
//    }
//    catch {
//        print("WRITE ERROR!!!")
//    }
//}
//
//static func editMovie(oldMovie: Movie, newMovie: Movie) {
//    do {
//        try realm.write {
//            oldMovie.touchedTime = newMovie.touchedTime
//            oldMovie.status = newMovie.status
//            oldMovie.myRuntime = newMovie.myRuntime
//            oldMovie.startDate = newMovie.startDate
//            oldMovie.endDate = newMovie.endDate
//        }
//    }
//    catch {
//        print("WRITE ERROR!!!")
//    }
//}
//
//
//static func delMovie(_ movie: Movie) {
//    // FIXME: ERROR!!!!
//    // Exception    NSException *    "'Movie' does not have a primary key defined"    0x0000600000041fe0
//    do {
//        guard let movieToDelete = realm.object(ofType: Movie.self, forPrimaryKey: movie.id) else {
//            return
//        }
//        
//        try realm.write {
//            realm.delete(movieToDelete)
//        }
//    }
//    catch {
//        print("DELETE ERROR!!!")
//    }
//}
