//
//  SearchResult.swift
//  RunningTime
//
//  Created by 김유진 on 11/10/23.
//

import Foundation

struct SearchViewModel: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
