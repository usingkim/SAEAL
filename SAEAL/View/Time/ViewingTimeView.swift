//
//  ViewingTimeView.swift
//  SAEAL
//
//  Created by 김유진 on 11/11/23.
//

import SwiftUI

struct ViewingTimeView: View {
    @ObservedObject var myMediaService: MyMediaService
    
    var body: some View {
        VStack {
            HStack {
                Text("기간 2024년")
                Spacer()
            }
            .padding()
            
            Spacer()
            if myMediaService.myRunningTime == -1 {
                Text("영화 기록을 시작해보세요!")
                Text("검색 후 저장을 시작하시면 됩니다!")
            }
            else {
                Text("\(myMediaService.myRunningTime / 60)시간 \(myMediaService.myRunningTime % 60)분")
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            myMediaService.resetRunningTime()
        }
    }
}

#Preview {
    ViewingTimeView(myMediaService: MyMediaService())
}
