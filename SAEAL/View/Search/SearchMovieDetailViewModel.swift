//
//  SearchMovieDetailViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class SearchMovieDetailViewModel: ObservableObject {
    
    @Published var movieDetail: TMDBService.MovieDetail?
    @Published var movieCredit: TMDBService.MovieCredit?
    @Published var director: String = ""
    @Published var actors: [String] = []
    @Published var isShowingSaveSheet: Bool = false
    @Published var isShowingSaveAlert: Bool = false
    @Published var status: DBMovie.Status? = nil
    @Published var watchedTime: Double = 0
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    
    func changeStatus(newStatus: DBMovie.Status) {
        if status == newStatus {
            status = nil
        }
        else {
            status = newStatus
        }
        if status == .bookmark {
            isShowingSaveAlert = true
        }
    }
    
    func getDetailAndCredit(movie: TMDBService.SearchMovie) {
        Task {
            if let detail = await TMDBService.getMovieDetailByID(id: movie.id) {
                movieDetail = detail
            }
            else {
                print("영화 정보가 없습니다.")
            }
            
            if let credit = await TMDBService.getMovieCreditByID(id: movie.id) {
                movieCredit = credit
                var numOfActor = 0
                for actor in credit.cast {
                    actors.append(actor.name)
                    numOfActor += 1
                    if numOfActor == 3 {
                        break
                    }
                }
                if let idx = movieCredit?.crew.firstIndex(where: { $0.job == "Directing" || $0.job ==  "Director" }) {
                    director = credit.crew[idx].name
                }
            }
            else {
                print("Credit 정보가 없습니다.")
            }
            
        }
    }
    
    func addMovie(newMovie: DBMovie) {
        do {
            try realm.write {
                realm.add(newMovie)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
    }
    
    func registerMovie(movie: TMDBService.SearchMovie) {
        switch(status) {
        case .bookmark:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.bookmark.rawValue, actors: actors, director: director, myRuntime: 0, startDate: nil, endDate: nil))
        case .ing:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.ing.rawValue, actors: actors, director: director, myRuntime: Int(watchedTime), startDate: startDate, endDate: nil))
        case .end:
            addMovie(newMovie: DBMovie(title: movie.title, MovieID: movie.id, runtime: movieDetail?.runtime ?? 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: DBMovie.Status.end.rawValue, actors: actors, director: director, myRuntime: movieDetail?.runtime ?? 0, startDate: startDate, endDate: endDate))
        case .none:
            print()
        }
    }
    
}
