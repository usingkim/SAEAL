//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

final class MyMediaService: ObservableObject {
    @Published var myMovies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    
    private var recentStatus: Int = -1
    public var myRunningTime: Int {
        if myMovies.isEmpty {
            return -1
        }
        
        var sum = 0
        for movie in myMovies {
            
            if movie.status == Status.end.rawValue {
                sum += movie.runtime
            }
            
            else if movie.status == Status.ing.rawValue {
                // sum += 본 만큼만
            }
        }
        return sum
    }
    
    func addMovie(newMovie: Movie) {
        myMovies.append(newMovie)
        Movie.addMovie(newMovie)
        self.filterMovies(status: recentStatus)
    }
    
    func delMovie(movie: Movie) {
        Movie.delMovie(movie)
        self.fetchAllMovie()
    }
    
    func fetchAllMovie() {
        myMovies = Array(Movie.findAll())
        self.filterMovies(status: recentStatus)
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
}
