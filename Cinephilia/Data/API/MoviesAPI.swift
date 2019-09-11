//
//  TrakApi.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/24/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import os.log
import Combine

class MoviesAPI {

    class func request<T: Decodable>(with url: URL, type: T.Type) -> AnyPublisher<T, Error> {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: url)
            .print()
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
        } .decode(type: type.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func movie(with id: Int) -> AnyPublisher<Movie, Error> {
        return MoviesAPI.request(with: MovieEndpoints.movie(id: id).url, type: Movie.self)
    }

    func movies(sorting: Sorting) -> AnyPublisher<Listing<Movie>, Error> {
        switch sorting {
        case .popular:
            return self.popularMovies()
        case .topRated:
            return self.topRatedMovies()
        case .coming:
            return self.upcomingMovies()
        }
    }

    func popularMovies() -> AnyPublisher<Listing<Movie>, Error> {
        return MoviesAPI.request(with: MovieEndpoints.popular.url, type: Listing<Movie>.self)
    }

    func topRatedMovies() -> AnyPublisher<Listing<Movie>, Error> {
        return MoviesAPI.request(with: MovieEndpoints.topRated.url, type: Listing<Movie>.self)
    }

    func upcomingMovies() -> AnyPublisher<Listing<Movie>, Error> {
        return MoviesAPI.request(with: MovieEndpoints.upcoming.url, type: Listing<Movie>.self)
    }

    func similarMovies(with id: Int) -> AnyPublisher<Listing<Movie>, Error> {
        return MoviesAPI.request(with: MovieEndpoints.similar(id: id).url, type: Listing<Movie>.self)
    }

    func movieGenres() -> AnyPublisher<GenreList, Error> {
        return MoviesAPI.request(with: MovieEndpoints.movieGenres.url, type: GenreList.self)
    }

    func search(query: String) -> AnyPublisher<Listing<Movie>, Error> {
        return MoviesAPI.request(with: MovieEndpoints.search(query: query).url, type: Listing<Movie>.self)
    }

    enum HTTPError: LocalizedError {
        case statusCode
    }
}
