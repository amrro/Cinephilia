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
    
    func popularTVShows() -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.popular.url, type: Listing<Show>.self)
    }
    
    
    func show(with id: Int) -> Promise<Show> {
        return MoviesAPI.request(with: ShowsEndpoints.show(id: id).url, type: Show.self)
    }
    
    
    func similarShows(with id: Int) -> Promise<Listing<Show>> {
        return MoviesAPI.request(with: ShowsEndpoints.similar(id: id).url, type: Listing<Show>.self)
    }
    
    
}
