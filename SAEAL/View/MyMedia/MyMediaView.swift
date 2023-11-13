//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI
import Kingfisher

struct MyMediaView: View {
    @ObservedObject var myMediaService: MyMediaService
    @State private var status: Status?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    status = nil
                    myMediaService.filterMovies(status: status?.hashValue ?? -1)
                }, label: {
                    Text("전체")
                })
                
                Button(action: {
                    status = .bookmark
                    myMediaService.filterMovies(status: status?.hashValue ?? -1)
                }, label: {
                    Text(Status.bookmark.statusString)
                })
                
                Button(action: {
                    status = .ing
                    myMediaService.filterMovies(status: status?.hashValue ?? -1)
                }, label: {
                    Text(Status.ing.statusString)
                })
                
                Button(action: {
                    status = .end
                    myMediaService.filterMovies(status: status?.hashValue ?? -1)
                }, label: {
                    Text(Status.end.statusString)
                })
            }
            
            List {
                ForEach(myMediaService.filteredMovies) { movie in
                    NavigationLink {
                        Text(movie.title)
                    } label: {
                        if let poster = movie.posterLink {
                            KFImage(URL(string: APIConstant.imageURL + poster))
                                .retry(maxCount: 3, interval: .seconds(5))
                                .resizable()
                                .frame(width: 128, height: 128)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        }
                        else {
                            HStack {
                                Text(movie.title)
                                Spacer()
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            myMediaService.delMovie(movie: movie)
                        } label: {
                            Text("삭제")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyMediaView(myMediaService: MyMediaService())
}
