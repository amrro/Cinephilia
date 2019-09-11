//
//  TVShow.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/2/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

struct Show: MediaItem, Codable {
    let id: Int
    let mediaType: String?
    let backdropPath: String?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genre]?
    let homepage: String?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: TEpisodeToAir?
    let name: String?
    let nextEpisodeToAir: TEpisodeToAir?
    let networks: [Network]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String?
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [Network]?
    let seasons: [Season]?
    let status: String?
    let type: String?
    let voteAverage: Double
    let voteCount: Int
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int
    let creditID, name: String
    let gender: Int
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}

// MARK: - TEpisodeToAir
struct TEpisodeToAir: Codable {
    let airDate: String?
    let episodeNumber, id: Int
    let name, overview, productionCode: String
    let seasonNumber: Int
    let showID: Int?
    let stillPath: String?
    let voteAverage, voteCount: Int

}

// MARK: - Network
struct Network: Codable {
    let name: String
    let id: Int
    let logoPath: String?
    let originCountry: String
}

// MARK: - Season
struct Season: Codable {
    let airDate: String
    let episodeCount, id: Int
    let name: String
    let overview, posterPath: String?
    let seasonNumber: Int
}

typealias Shows = Listing<Show>
