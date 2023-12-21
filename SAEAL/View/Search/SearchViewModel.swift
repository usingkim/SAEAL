//
//  SearchViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var movies: [TMDBService.SearchMovie] = []
    @Published var isShowingAlert: Bool = false
    @Published var isSearched: Bool = false
    
    func search() {
        Task {
            if let m = await TMDBService.findMoviebyString(word: searchText) {
                movies = m
            }
        }
        isSearched = true
    }
}
