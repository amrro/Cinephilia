//
//  File.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/24/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let id: Int
    let mediaType: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let adult: Bool
    let homepage: String?
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let genres: [Genre]?
    let revenue: Int?
    let runtime: Int?
    let title: String
    let voteAverage: Double
    let overview, releaseDate: String
}
