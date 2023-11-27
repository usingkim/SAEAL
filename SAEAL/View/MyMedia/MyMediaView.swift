//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI
import Kingfisher

struct MyMediaView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var myMediaService: MyMediaService
    @State private var status: DBMovie.Status?
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    status = nil
                    myMediaService.filterMovies(status: status?.rawValue ?? -1)
                }, label: {
                    Text("전체")
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .bookmark
                    myMediaService.filterMovies(status: DBMovie.Status.bookmark.rawValue)
                }, label: {
                    Text(DBMovie.Status.bookmark.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .ing
                    myMediaService.filterMovies(status: DBMovie.Status.ing.rawValue)
                }, label: {
                    Text(DBMovie.Status.ing.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .end
                    myMediaService.filterMovies(status: DBMovie.Status.end.rawValue)
                }, label: {
                    Text(DBMovie.Status.end.statusString)
                })
                .buttonStyle(.plain)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(myMediaService.filteredMovies) { movie in
                        NavigationLink {
                            MyMediaDetailView(myMediaService: MyMediaService(), movie: movie)
                        } label: {
                            OneMovieCapsule(movie: movie)
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MyMediaView(myMediaService: MyMediaService())
}
