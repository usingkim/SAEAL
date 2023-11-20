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
            Text("\(myMediaService.myRunningTime / 60)시간 \(myMediaService.myRunningTime % 60)분")
        }
    }
}

#Preview {
    ViewingTimeView(myMediaService: MyMediaService())
}
