//
//  Listing.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/2/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

struct Listing<T: Codable>: Codable {
    let page, totalResults, totalPages: Int
    let results: [T]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
