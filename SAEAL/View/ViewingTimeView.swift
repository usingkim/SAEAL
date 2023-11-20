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
            if myMediaService.myRunningTime == -1 {
                Text("영화 기록을 시작해보세요!")
                Text("검색 후 영화를 기록하면 됩니당 ㅋ")
            }
            else {
                Text("\(myMediaService.myRunningTime / 60)시간 \(myMediaService.myRunningTime % 60)분")
            }

        }
    }
}

#Preview {
    ViewingTimeView(myMediaService: MyMediaService())
}
