//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

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

#Preview {
    MyMediaView(myMedias: MyMediaService())
}
