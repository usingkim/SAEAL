//
//  OneMovieCapsule.swift
//  SAEAL
//
//  Created by 김유진 on 11/27/23.
//

import SwiftUI
import Kingfisher

struct OneMovieCapsule: View {
    enum Mode {
        case search
        case myMedia
    }
    
    @State var mode: Mode = .search
    @State var movie: DBMovie
    
    var body: some View {
        HStack {
            if let poster = movie.posterLink {
                KFImage(URL(string: APIConstant.imageURL + poster))
                    .retry(maxCount: 3, interval: .seconds(5))
                    .resizable()
                    .frame(width: 80, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            else {
                Image(.loading)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, content: {
                Text(movie.title)
                    .lineLimit(1)
                    .font(.title04)
                    .foregroundColor(.black)
                Text("\(movie.releaseDate)")
                    .font(.body04)
                    .foregroundColor(.black)
                Spacer()
                if mode == .myMedia {
                    if let status = DBMovie.Status.getStatusByInt(movie.status) {
                        switch status {
                        case .bookmark:
                            Text(status.statusString)
                                .font(.caption01)
                                .foregroundColor(.black)
                        case .ing:
                            if let start = movie.startDate {
                                Text("\(start.yearMonthDay) ~ 보는 중")
                                    .font(.caption01)
                                    .foregroundColor(.black)
                            }
                        case .end:
                            if let start = movie.startDate {
                                if let end = movie.endDate {
                                    Text("\(start.yearMonthDay) ~ \(end.yearMonthDay) 다 봤어요")
                                        .font(.caption01)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                    }
                }
            })
            Spacer()
            
            if mode == .search {
                Image(.addButton)
            }
        }
    }
}

#Preview {
    OneMovieCapsule(movie: DBMovie(title: "서울의 밤", MovieID: 1, runtime: 123, posterLink: "", touchedTime: Date.now, releaseDate: "2023-11-23", overview: "서울의밤을 보시겟나염", status: 1, actors: [], director: "", myRuntime: 123, startDate: nil, endDate: nil))
}
