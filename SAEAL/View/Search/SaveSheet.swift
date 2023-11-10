//
//  SaveSheet.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SaveSheet: View {
    @Binding var status: Status
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    status = .bookmark
                } label: {
                    Text("보고싶어요!")
                }
                
                Button {
                    status = .ing
                } label: {
                    Text("쉿! 보는중!")
                }

                Button {
                    status = .end
                } label: {
                    Text("다 봤어요!")
                }
                
                
            }
        }
    }
}

#Preview {
    SaveSheet(status: .constant(.bookmark))
}
