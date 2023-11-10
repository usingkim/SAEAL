//
//  MovieDetail.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

struct MovieDetail: Codable {
    var title: String
    var original_language: String
    var original_title: String
    var overview: String
    var runtime: Int
    var status: String
}
