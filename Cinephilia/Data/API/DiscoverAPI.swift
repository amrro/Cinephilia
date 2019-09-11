//
//  DiscoverAPI.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/11/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import Combine

class DiscoverAPI {

    enum MediaType: String {
        case all
        case movie
        case tv
    }

    func trending(type: MediaType = .all) -> AnyPublisher<Trending, Error> {
        let url = URL(string: "https://api.themoviedb.org/3/trending/\(type.rawValue)/day?api_key=f5d2da75e7729eee412a43da5f542a9c")!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw MoviesAPI.HTTPError.statusCode
                }
                return output.data
        }.decode(type: Trending.self, decoder: decoder)
            .eraseToAnyPublisher()

    }
}
