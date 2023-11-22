//
//  MyMediaDetailView.swift
//  SAEAL
//
//  Created by 김유진 on 11/20/23.
//

import SwiftUI

struct MyMediaDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var myMediaService: MyMediaService
    @State var movie: DBMovie
    @State private var isShowingEditSheet: Bool = false
    
    var body: some View {
        VStack {
            Text(movie.title)
            Text("\(movie.status)")
            Text("내 러닝타임 : \(movie.myRuntime)")
            Text(Status.getStatusByInt(movie.status)?.statusString ?? "")
        }
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
                    myMediaService.delMovie(movie: movie)
                    dismiss()
                }, label: {
                    Text("삭제")
                })
            }
        })
    }
}

#Preview {
    MyMediaDetailView(myMediaService: MyMediaService(), movie: DBMovie(title: "", MovieID: 0, runtime: 0, posterLink: nil, touchedTime: Date.now, status: 0, myRuntime: 0, startDate: nil, endDate: nil))
}
