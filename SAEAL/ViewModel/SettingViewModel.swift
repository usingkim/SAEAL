//
//  SettingViewModel.swift
//  SAEAL
//
//  Created by 김유진 on 12/22/23.
//

import Foundation

final class SettingViewModel: ObservableObject {
    
    @Published var isShowingMailView = false
    @Published var resetAlert = false
    @Published var cantSend: Bool = false
    
    func delAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            print("DELETE ERROR!!!")
        }
    }
}
