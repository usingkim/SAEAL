//
//  MyPageView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            Section("내 정보") {
                Text("프로필 변경")
            }
            
            Section("지원") {
                Text("자주 묻는 질문")
                Text("버그/오류")
            }
            
            Section("기타") {
                Text("평점 남기기")
                Text("개발자 소개")
            }
        }
    }
}

#Preview {
    SettingView()
}
