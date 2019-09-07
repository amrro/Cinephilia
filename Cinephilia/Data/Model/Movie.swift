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
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
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

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id, adult
        case homepage
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genres
        case revenue, runtime
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}
