//
//  TMDBRepository.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/27/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import PromiseKit


class TMDBRepository {
    private let api: TMDBApi
    private let persistentData: PersistentData
    
    init(api: TMDBApi, persistentData: PersistentData) {
        self.api = api
        self.persistentData = persistentData
    }
    
    func popularMovies() -> Promise<Listing<Movie>> {
        return api.popularMovies()
    }
    
    func movie(id: Int) -> Promise<Movie>{
        return api.movie(with: id)
    }
    
}
