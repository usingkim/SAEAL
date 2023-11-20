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
    @State private var status: Status?
    
    @State private var isShowingEditSheet: Bool = false
    
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
                    myMediaService.filterMovies(status: Status.bookmark.rawValue)
                }, label: {
                    Text(Status.bookmark.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .ing
                    myMediaService.filterMovies(status: Status.ing.rawValue)
                }, label: {
                    Text(Status.ing.statusString)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    status = .end
                    myMediaService.filterMovies(status: Status.end.rawValue)
                }, label: {
                    Text(Status.end.statusString)
                })
                .buttonStyle(.plain)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(myMediaService.filteredMovies) { movie in
                        NavigationLink {
                            MyMediaDetailView(myMediaService: MyMediaService(), movie: movie)
                                .toolbar(content: {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button(action: {
                                            isShowingEditSheet = true
                                        }, label: {
                                            Text("수정")
                                        })
                                        .sheet(isPresented: $isShowingEditSheet, content: {
                                            EditSheetView(myMediaService: myMediaService, movie: movie, isShowingEditSheet: $isShowingEditSheet)
                                                .presentationDetents([.medium])
                                        })
                                    }
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button(action: {
                                            dismiss()
                                            myMediaService.delMovie(movie: movie)
                                        }, label: {
                                            Text("삭제")
                                        })
                                    }
                                })
                        } label: {
                            VStack {
                                if let poster = movie.posterLink {
                                    KFImage(URL(string: APIConstant.imageURL + poster))
                                        .retry(maxCount: 3, interval: .seconds(5))
                                        .resizable()
                                        .frame(width: 120, height: 150)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                    Text(movie.title)
                                        .lineLimit(1)
                                }
                                else {
                                    Spacer()
                                    Text(movie.title)
                                }
                            }
                            .padding()
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct EditSheetView: View {
    
    @ObservedObject var myMediaService: MyMediaService
    
    @State var movie: Movie
    @Binding var isShowingEditSheet: Bool
    
    @State private var status: Status = .bookmark
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Status.allCases, id:\.self) { s in
                    Button {
                        status = s
                    } label: {
                        Text(s.statusString)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("\(status.statusString)")
            
            Button {
//                movie.status = status.rawValue
                myMediaService.editMovie(oldMovie: movie, newStatus: status)
                isShowingEditSheet = false
            } label: {
                Text("저장")
            }
            
        }
    }
}

#Preview {
    MyMediaView(myMediaService: MyMediaService())
}
