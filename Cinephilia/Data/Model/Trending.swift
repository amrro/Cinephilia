//
//  Trending.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/10/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

struct Trending: Decodable {
    let page: Int
    let results: [Media]

    enum CodingKeys: String, CodingKey {
        case page
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        var data =  try container.nestedUnkeyedContainer(forKey: .results)
        var resultsArray = [Media]()

        while !data.isAtEnd {
            do {
                if let movie = try? data.decode(Movie.self) {
                    resultsArray.append(.movie(item: movie))
                } else if let show = try? data.decode(Show.self) {
                    resultsArray.append(.tv(item: show))
                } else {
                    resultsArray.append(.undefined)
                }
            }
        }
        self.results = resultsArray
    }

}
