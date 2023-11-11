//
//  MyMediaService.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

class MyMediaService: ObservableObject {
    // Singleton 고민해보기
    @Published var myMedias: [Media] = []
    @Published var filteredMedias: [Media] = []
    
    func addMedia(newMedia: Media) {
        myMedias.append(newMedia)
    }
    
    func filterStatus(status: Status?) {
        if status == nil {
            filteredMedias = myMedias
        }
        else {
            for media in myMedias {
                if media.status == status {
                    filteredMedias.append(media)
                }
            }
        }
    }
}
