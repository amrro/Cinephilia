//
//  Sorting.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/7/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

enum Sorting: String {
    case popular = "Popular"
    case topRated = "Top Rated"
    case coming = "Upcoming"
    
    
    static var values: [Sorting] {
            return [.popular, .topRated, .coming]
    }
}
