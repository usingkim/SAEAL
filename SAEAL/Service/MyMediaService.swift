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
        
        if let s = Status.getStatusByInt(status) {
            filteredMovies = myMovies.filter { movie in
                movie.status == status
            }
        }
        else {
            filteredMovies = myMovies
        }
    }
}
