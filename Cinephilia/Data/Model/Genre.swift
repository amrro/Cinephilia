//
//  Genre.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/27/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation

// MARK: - Genre
struct GenreList: Codable {
    let genres: [Genre]
}

struct Genre: Codable, CustomStringConvertible {
    var description: String {
        switch self.name {
        case "Action":
            return "\(name) 🏃🏻‍♀️"
        case "Adventure":
            return "\(name) 🗺"
        case "Animation":
            return "\(name) 🐉"
        case "Comedy":
            return "\(name) 😄"
        case "Crime":
            return "\(name) 🔪"
        case "Documentary":
            return "\(name) 🔭"
        case "Drama":
            return "\(name) 🎭"
        case "Family":
            return "\(name) 👨‍👩‍👧"
        case "Fantasy":
            return "\(name) 🧜🏻‍♀️"
        case "History":
            return "\(name) 🔭"
        case "Horror":
            return "\(name) 😱"
        case "Music":
            return "\(name) 🎻"
        case "Mystery":
            return "\(name) ☢️"
        case "Romance":
            return "\(name) 💔"
        case "Science Fiction":
            return "Sci-Fi 🤖"
        case "TV Movie":
            return "\(name) 📺"
        case "Thriller":
            return "\(name) 😐"
        case "War":
            return "\(name) ☢️"
        case "Western":
            return "\(name) 🎅🏻"
        default:
            return name
        }
    }
    
    let id: Int
    let name: String
}
