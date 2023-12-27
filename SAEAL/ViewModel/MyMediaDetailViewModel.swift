//
//  MyMediaDetailViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class MyMediaDetailViewModel: MyMediaViewModel {
    @Published var isShowingEditSheet: Bool = false
    @Published var isShowingDeleteAlertSheet: Bool = false
    @Published var isShowingBookmarkAlert: Bool = false
    @Published var watchedTime: Double = 0
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    
    func editMovie(oldMovie: DBMovie, newMovie: DBMovie) {
        
        newMovie.touchedTime = Date.now
        if let s = status {
            switch(s) {
            case .bookmark:
                newMovie.status = DBMovie.Status.bookmark.rawValue
                newMovie.myRuntime = 0
                newMovie.startDate = nil
                newMovie.endDate = nil
            case .ing:
                newMovie.status = DBMovie.Status.ing.rawValue
                newMovie.myRuntime = Int(watchedTime)
                newMovie.startDate = startDate
                newMovie.endDate = nil
            case .end:
                newMovie.status = DBMovie.Status.end.rawValue
                newMovie.myRuntime = oldMovie.runtime
                newMovie.startDate = startDate
                newMovie.endDate = endDate
            }
        }
        
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
        
        isShowingEditSheet = false
    }
    
    func openSheet(s: DBMovie.Status) {
        if status != .bookmark {
            isShowingEditSheet = true
        }
        else {
            isShowingBookmarkAlert = true
        }
        status = s
    }
    
    func setStatus(s: Int) {
        status = DBMovie.Status.getStatusByInt(s)
    }
}
