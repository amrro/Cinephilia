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
}
