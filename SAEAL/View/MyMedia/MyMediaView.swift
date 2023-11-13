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
            //            Menu {
            //                Picker(selection: $status, label: Text("Sorting options")) {
            //                    ForEach(Status.allCases, id:\.self) { status in
            //                        Text(status.statusString)
            //                    }
            //                }
            //            } label: {
            //                Text("상태값")
            //            }
            //            .onChange(of: status, perform: { value in
            //                myMedias.filterStatus(status: status)
            //            })
            List {
                ForEach(myMediaService.myMovies) { movie in
                    NavigationLink {
                        Text(movie.title)
                    } label: {
                        if let poster = movie.posterLink {
                            KFImage(URL(string: APIConstant.imageURL + poster))
                                .retry(maxCount: 3, interval: .seconds(5))
                                .resizable()
                                .frame(width: 128, height: 128) //resize
                                .cornerRadius(20) //둥근 코너 설정
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
                        
                        Button(role: .none) {
                            // 확인해봐야한다.
//                            myMedias.editMovie(oldMovie: <#T##Movie#>, newMovie: <#T##Movie#>)
                            
                        } label: {
                            Text("수정")
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
