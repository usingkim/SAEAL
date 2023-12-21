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
}
