//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI
import Kingfisher

struct MyMediaView: View {
    @ObservedObject var myMedias: MyMediaService
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
            
            
            List(myMedias.myMedias) { media in
                NavigationLink {
                    
                    Text(media.title)
                    Text(media.status.statusString)
                    
                } label: {
                    if let poster = media.posterLink {
                        KFImage(URL(string: APIConstant.imageURL + poster))
                            .retry(maxCount: 3, interval: .seconds(5))
                            .resizable()
                                              .frame(width: 128, height: 128) //resize
                                              .cornerRadius(20) //둥근 코너 설정
                                              .shadow(radius: 5)
                    }
                    else {
                        HStack {
                            Text(media.title)
                            Spacer()
                            Text("\(media.allOfRunTime)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyMediaView(myMedias: MyMediaService())
}
