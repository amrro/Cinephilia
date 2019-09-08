//
//  ShowsAPI.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/7/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import Combine


class ShowsAPI {
    // MARK: - TV shows
    
    func shows(with sorting: Sorting) -> AnyPublisher<Listing<Show>, Error> {
        switch sorting {
        case .popular:
            return self.popularShows()
        case .topRated:
            return self.topRatedShows()
        case .coming:
            return self.upcomingShows()
        }
    }
    
    func popularShows() -> AnyPublisher<Listing<Show>, Error> {
        return MoviesAPI.request(with: ShowsEndpoints.popular.url, type: Listing<Show>.self)
    }
    
    func topRatedShows() -> AnyPublisher<Listing<Show>, Error> {
        return MoviesAPI.request(with: ShowsEndpoints.topRated.url, type: Listing<Show>.self)
    }
    
    func upcomingShows() -> AnyPublisher<Listing<Show>, Error> {
        return MoviesAPI.request(with: ShowsEndpoints.upcoming.url, type: Listing<Show>.self)
    }
    
    
    func show(with id: Int) -> AnyPublisher<Show, Error> {
        return MoviesAPI.request(with: ShowsEndpoints.show(id: id).url, type: Show.self)
    }
    
    
    func similarShows(with id: Int) -> AnyPublisher<Listing<Show>, Error> {
        return MoviesAPI.request(with: ShowsEndpoints.similar(id: id).url, type: Listing<Show>.self)
    }
    
    func tvGenres() -> AnyPublisher<GenreList, Error> {
        return MoviesAPI.request(with: MovieEndpoints.tvGenres.url, type: GenreList.self)
    }
    
    
}
