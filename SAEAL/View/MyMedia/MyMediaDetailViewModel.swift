//
//  MyMediaDetailViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class MyMediaDetailViewModel: ObservableObject {
    @Published var isShowingEditSheet: Bool = false
    @Published var isShowingDeleteAlertSheet: Bool = false
    @Published var isShowingBookmarkAlert: Bool = false
    @Published var status: DBMovie.Status? = .bookmark
    @Published var watchedTime: Double = 0
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    
    func editMovie(oldMovie: DBMovie, newMovie: DBMovie) {
        
        let movie = oldMovie
        movie.touchedTime = newMovie.touchedTime
        movie.status = newMovie.status
        movie.myRuntime = newMovie.myRuntime
        movie.startDate = newMovie.startDate
        movie.endDate = newMovie.endDate
        
        do {
            try realm.write {
                realm.add(movie, update: .all)
            }
        }
        catch {
            print("WRITE ERROR!!!")
        }
    }
    
}
