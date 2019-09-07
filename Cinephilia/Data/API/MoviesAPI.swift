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

class MoviesAPI {
    
    class func request<T: Decodable>(with url: URL, type: T.Type) -> Promise<T> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
            }.map{
                return try JSONDecoder().decode(type.self, from: $0.data)
        }
    }
    
    func movie(with id: Int) -> Promise<Movie> {
        return MoviesAPI.request(with: MovieEndpoints.movie(id: id).url, type: Movie.self)
    }
    
    
    func movies(sorting: Sorting) -> Promise<Listing<Movie>> {
        switch sorting {
        case .popular:
            return self.popularMovies()
        case .topRated:
            return self.topRatedMovies()
        case .coming:
            return self.upcomingMovies()
        }
    }
    
    func popularMovies() -> Promise<Listing<Movie>> {
        return MoviesAPI.request(with: MovieEndpoints.popular.url, type: Listing<Movie>.self)
    }
    
    func topRatedMovies() -> Promise<Listing<Movie>> {
        return MoviesAPI.request(with: MovieEndpoints.topRated.url, type: Listing<Movie>.self)
    }
    
    func upcomingMovies() -> Promise<Listing<Movie>> {
        return MoviesAPI.request(with: MovieEndpoints.upcoming.url, type: Listing<Movie>.self)
    }
    
    func similarMovies(with id: Int) -> Promise<Listing<Movie>> {
        return MoviesAPI.request(with: MovieEndpoints.similar(id: id).url, type: Listing<Movie>.self)
    }
    
    
    func movieGenres() -> Promise<GenreList> {
        return MoviesAPI.request(with: MovieEndpoints.movieGenres.url, type: GenreList.self)
    }
    
    
    func search(query: String) -> Promise<Listing<Movie>> {
        return MoviesAPI.request(with: MovieEndpoints.search(query: query).url, type: Listing<Movie>.self)
    }
    

    
    
    enum HTTPError: Error {
        case NetworkError(url: URL, statusCode: Int)
        case URLError(_ url: String)
    }
}
