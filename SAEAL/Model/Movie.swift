//
//  Movie.swift
//  SAEAL
//
//  Created by 김유진 on 11/13/23.
//

import Foundation
import RealmSwift

final class Movie: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    @Persisted var MovieID: Int
    @Persisted var runtime: Int
    @Persisted var posterLink: String?
    @Persisted var touchedTime: Date
    @Persisted var status: Int
    
    override init() {
        super.init()
        self.id = UUID().uuidString
        self.title = ""
        self.MovieID = 0
        self.runtime = 0
        self.posterLink = nil
        self.touchedTime = Date.now
        self.status = 0
    }
    
    init(title: String, MovieID: Int, runtime: Int, posterLink: String?, touchedTime: Date, status: Int) {
        super.init()
        self.id = UUID().uuidString
        self.title = title
        self.MovieID = MovieID
        self.runtime = runtime
        self.posterLink = posterLink
        self.touchedTime = touchedTime
        self.status = status
    }
    
    private static var realm: Realm = try! Realm()
    
    static func addMovie(_ movie: Movie) {
        do {
            try realm.write {
                realm.add(movie)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
    }
    
    static func findAll() -> Results<Movie> {
        return realm.objects(Movie.self)
    }
    
    static func editMovie(movie: Movie, newStatus: Status) {
        do {
            try realm.write {
                movie.status = newStatus.rawValue
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
    }
    
    
    static func delMovie(_ movie: Movie) {
        // FIXME: ERROR!!!!
        // Exception    NSException *    "'Movie' does not have a primary key defined"    0x0000600000041fe0
        do {
            guard let movieToDelete = realm.object(ofType: Movie.self, forPrimaryKey: movie.id) else {
                return
            }
            
            try realm.write {
                realm.delete(movieToDelete)
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
        
    }
}
