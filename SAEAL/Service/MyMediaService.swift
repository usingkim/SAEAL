//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

final class MyMediaService: ObservableObject {
    @Published var myMovies: [Movie] = []
    
    func addMovie(newMovie: Movie) {
        myMovies.append(newMovie)
        Movie.addMovie(newMovie)
    }
    
    func delMovie(movie: Movie) {
        Movie.delMovie(movie)
        self.fetchAllMovie()
    }
    
    func editMovie(oldMovie: Movie, newMovie: Movie) {
        Movie.editMovie(oldMovie: oldMovie, newMovie: newMovie)
        self.fetchAllMovie()
    }
    
    func fetchAllMovie() {
        myMovies = Array(Movie.findAll())
    }
}
