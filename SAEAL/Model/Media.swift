//
//  Media.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

// 나의 미디어(드라마/ 영화)
struct Media: Identifiable {
    var id: UUID = UUID()
    
    var type: MediaType
    var title: String
    var MovieID: Int
    var runtime: [Int]
    var posterLink: String?
    var touchedTime: Date = Date.now
    var status: Status
    
    var allOfRunTime: Int {
        var sum = 0
        for time in runtime {
            sum += time
        }
        return sum
    }
}
