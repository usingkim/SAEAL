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
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    status = nil
                    myMediaService.filterMovies(status: status?.rawValue ?? -1)
                }, label: {
                    Text("전체")
                        .font(.body01)
                        .padding(.top, 8)
                        .padding(.leading, 15)
                        .padding(.trailing, 14)
                        .padding(.bottom, 8)
                })
                .buttonStyle(.plain)
                .foregroundStyle(status == nil ? Color.black : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(status == nil ? Color.black : Color.gray, lineWidth: 1)
                )
                
                Button(action: {
                    status = .bookmark
                    myMediaService.filterMovies(status: DBMovie.Status.bookmark.rawValue)
                }, label: {
                    Text(DBMovie.Status.bookmark.statusString)
                        .font(.body01)
                        .padding(.top, 8)
                        .padding(.leading, 15)
                        .padding(.trailing, 14)
                        .padding(.bottom, 8)
                })
                .buttonStyle(.plain)
                .foregroundStyle(status == .bookmark ? Color.black : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(status == .bookmark ? Color.black : Color.gray, lineWidth: 1)
                )
                
                Button(action: {
                    status = .ing
                    myMediaService.filterMovies(status: DBMovie.Status.ing.rawValue)
                }, label: {
                    Text(DBMovie.Status.ing.statusString)
                        .font(.body01)
                        .padding(.top, 8)
                        .padding(.leading, 15)
                        .padding(.trailing, 14)
                        .padding(.bottom, 8)
                })
                .buttonStyle(.plain)
                .foregroundStyle(status == .ing ? Color.black : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(status == .ing ? Color.black : Color.gray, lineWidth: 1)
                )
                
                Button(action: {
                    status = .end
                    myMediaService.filterMovies(status: DBMovie.Status.end.rawValue)
                }, label: {
                    Text(DBMovie.Status.end.statusString)
                        .font(.body01)
                        .padding(.top, 8)
                        .padding(.leading, 15)
                        .padding(.trailing, 14)
                        .padding(.bottom, 8)
                })
                .buttonStyle(.plain)
                .foregroundStyle(status == .end ? Color.black : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(status == .end ? Color.black : Color.gray, lineWidth: 1)
                )
            }
            .padding()
            
            ScrollView {
                
                ForEach(myMediaService.filteredMovies) { movie in
                    NavigationLink {
                        MyMediaDetailView(myMediaService: MyMediaService(), movie: movie)
                    } label: {
                        OneMovieCapsule(mode: .myMedia, movie: movie)
                    }
                    
                }
                
                .padding(.horizontal)
                .refreshable {
                    status = nil
                    myMediaService.fetchAllMovie()
                }
            }
            .padding(.trailing, 16)
        }
    }
}

#Preview {
    MyMediaView(myMediaService: MyMediaService())
}
