//
//  ShowsAPI.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/7/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import PromiseKit


class ShowsAPI {
    // MARK: - TV shows
    
    func shows(with sorting: Sorting) -> Promise<Listing<Show>> {
        switch sorting {
        case .popular:
            return self.popularShows()
        case .topRated:
            return self.topRatedShows()
        case .coming:
            return self.upcomingShows()
        }
    }
    
    func popularShows() -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.popular.url, type: Listing<Show>.self)
    }
    
    func topRatedShows() -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.topRated.url, type: Listing<Show>.self)
    }
    
    func upcomingShows() -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.upcoming.url, type: Listing<Show>.self)
    }
    
    
    func show(with id: Int) -> Promise<Show> {
        return MoviesAPI.request(with: ShowsEndpoints.show(id: id).url, type: Show.self)
    }
    
    
    func similarShows(with id: Int) -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.similar(id: id).url, type: Listing<Show>.self)
    }
    
    func tvGenres() -> Promise<GenreList> {
        return MoviesAPI.request(with: MovieEndpoints.tvGenres.url, type: GenreList.self)
    }
    
    
}
