//
//  Media.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

struct Media: Identifiable {
    var id: UUID = UUID()
    
    var type: MediaType
    var title: String
    var MovieID: Int
    var runtime: [Int]
    var posterLink: String?
    
    var allOfRunTime: Int {
        var sum = 0
        for time in runtime {
            sum += time
        }
        return sum
    }
}
