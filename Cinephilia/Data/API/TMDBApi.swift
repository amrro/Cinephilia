//
//  TrakApi.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/24/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import os.log
import PromiseKit


class TMDBApi {
    
    class func request<T: Decodable>(with url: URL, type: T.Type) -> Promise<T>{
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
            }.map{
                return try JSONDecoder().decode(type.self, from: $0.data)
        }
    }
    
    func movie(with id: Int) -> Promise<Movie> {
        return TMDBApi.request(with: MovieEndpoints.movie(id: id).url, type: Movie.self)
    }
    
    func popularMovies() -> Promise<Listing<Movie>> {
        return TMDBApi.request(with: MovieEndpoints.popular.url, type: Listing<Movie>.self)
    }
    
    
    func topRatedMovies() -> Promise<Listing<Movie>> {
        return TMDBApi.request(with: MovieEndpoints.topRated.url, type: Listing<Movie>.self)
    }
    
    func similarMovies(with id: Int) -> Promise<Listing<Movie>> {
        return TMDBApi.request(with: MovieEndpoints.similar(id: id).url, type: Listing<Movie>.self)
    }
    
    
    func movieGenres() -> Promise<GenreList> {
        return TMDBApi.request(with: MovieEndpoints.movieGenres.url, type: GenreList.self)
    }
    
    
    func tvGenres() -> Promise<GenreList> {
        return TMDBApi.request(with: MovieEndpoints.tvGenres.url, type: GenreList.self)
    }
    
    
    func search(query: String) -> Promise<Listing<Movie>> {
        return TMDBApi.request(with: MovieEndpoints.search(query: query).url, type: Listing<Movie>.self)
    }
    
    // MARK: - TV shows
    func popularTVShows() -> Promise<Listing<Show>> {
        return TMDBApi.request(with: ShowsEndpoints.popular.url, type: Listing<Show>.self)
    }
    
    
    func show(with id: Int) -> Promise<Show> {
        return TMDBApi.request(with: ShowsEndpoints.show(id: id).url, type: Show.self)
    }
    
    
    func similarShows(with id: Int) -> Promise<Listing<Show>> {
        return TMDBApi.request(with: ShowsEndpoints.similar(id: id).url, type: Listing<Show>.self)
    }
    
    
    
    
    enum HTTPError: Error {
        case NetworkError(url: URL, statusCode: Int)
        case URLError(_ url: String)
    }
}
