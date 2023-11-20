//
//  SaveSheetView.swift
//  SAEAL
//
//  Created by 김유진 on 11/20/23.
//

import SwiftUI

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

//#Preview {
//    SaveSheetView()
//}

