//
//  MediaItem.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/10/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

protocol MediaItem {
    var id: Int { get }
    var mediaType: String? { get }
}

enum Media {
    case movie(item: Movie)
    case tv(item: Show)
    case undefined
}
