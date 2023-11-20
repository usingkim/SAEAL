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
    
    @Published var myRunningTime: Int = -1
    
    private var recentStatus: Int = -1
    
    func addMovie(newMovie: Movie) {
        myMovies.append(newMovie)
        Movie.addMovie(newMovie)
        self.filterMovies(status: recentStatus)
        resetRunningTime()
    }
    
    func editMovie(oldMovie: Movie, newStatus: Status) {
        Movie.editMovie(movie: oldMovie, newStatus: newStatus)
        self.fetchAllMovie()
    }
    
    func delMovie(movie: Movie) {
        myMovies = []
        filteredMovies = []
        Movie.delMovie(movie)
        self.fetchAllMovie()
    }
    
    func fetchAllMovie() {
        myMovies = Array(Movie.findAll())
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
            
            if movie.status == Status.end.rawValue {
                myRunningTime += movie.runtime
            }
            
            else if movie.status == Status.ing.rawValue {
                // sum += 본 만큼만
            }
        }
    }
}
