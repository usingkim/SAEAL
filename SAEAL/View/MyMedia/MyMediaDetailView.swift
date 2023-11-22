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
    @State var movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.title)
            Text("\(movie.status)")
            Text("내 러닝타임 : \(movie.myRuntime)")
            Text(Status.getStatusByInt(movie.status)?.statusString ?? "")
        }
        
    }
}

#Preview {
    MyMediaDetailView(myMediaService: MyMediaService(), movie: Movie(title: "", MovieID: 0, runtime: 0, posterLink: nil, touchedTime: Date.now, status: 0, myRuntime: 0, startDate: nil, endDate: nil))
}
