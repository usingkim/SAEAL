//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct MyMediaView: View {
    @ObservedObject var myMedias: MyMediaService
    
    var body: some View {
        VStack {
            List(myMedias.myMedias) { media in
                HStack {
                    Text(media.title)
                    Spacer()
                    Text("\(media.allOfRunTime)")
                }
                
            }
            
        }
    }
}

#Preview {
    MyMediaView(myMedias: MyMediaService())
}
