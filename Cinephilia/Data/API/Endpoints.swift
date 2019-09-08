//
//  TMDBEndpoints.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/26/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//
import Foundation

fileprivate  let API_KEY = "f5d2da75e7729eee412a43da5f542a9c"
fileprivate  let BASE_URL = "https://api.themoviedb.org/3"
fileprivate  let API_KEY_PARM = "?api_key=\(API_KEY)"

fileprivate func buildURL(including path: String) -> String {
    return BASE_URL + path + API_KEY_PARM
}


enum MovieEndpoints {

    
    case popular
    case topRated
    case upcoming
    case posterImage(path: String)
    case movie(id: Int)
    case similar(id: Int)
    case movieGenres
    case tvGenres
    case search(query: String)
    
    
    var stringValue: String {
        switch self {
        case .popular:
            return BASE_URL + "/movie/popular" + API_KEY_PARM
        case .topRated:
            return BASE_URL + "/movie/top_rated" + API_KEY_PARM
        case .upcoming:
            return BASE_URL + "/movie/upcoming" + API_KEY_PARM
        case .movie (let id):
            return BASE_URL + "/movie/\(id)" + API_KEY_PARM
        case .similar (let id):
            return BASE_URL + "/movie/\(id)/similar" + API_KEY_PARM
        case .posterImage(let path):
            return "https://image.tmdb.org/t/p/w500/" + path
        case .movieGenres:
            return BASE_URL + "/genre/movie/list" + API_KEY_PARM
        case .tvGenres:
            return BASE_URL + "/genre/tv/list" + API_KEY_PARM
        case .search(let query):
            return BASE_URL + "/search/movie" + API_KEY_PARM + "&query=\(query)"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
}


enum ShowsEndpoints {
    
    case popular
    case topRated
    case upcoming
    case posterPath(path: String)
    case show(id: Int)
    case similar(id: Int)

    
    
    var stringValue: String {
        switch self {
        case .popular:
            return buildURL(including: "/tv/popular")
        case .topRated:
            return buildURL(including: "/tv/top_rated")
        case .upcoming:
            return buildURL(including: "/tv/upcoming")
        case .posterPath(let path):
            return "https://image.tmdb.org/t/p/w500" + path
        case .show(let id):
            return buildURL(including: "/tv/\(id)")
        case .similar(let id):
            return buildURL(including: "/tv/\(id)/similar")

        }
    }
    
    
    var url: URL {
        return URL(string: stringValue)!
    }
}

