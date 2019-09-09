//
//  ReleatedMovieCellCollectionViewCell.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/1/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Kingfisher

class SimilarElementCell: UICollectionViewCell {

    @IBOutlet weak var moviePoster: UIImageView!

    var posterPath: String? {
        didSet {
            guard let posterPath = posterPath else { return }
            let url = MovieEndpoints.posterImage(path: posterPath).url
            let processor = RoundCornerImageProcessor(cornerRadius: 40)

            moviePoster.kf.indicatorType = .activity
            moviePoster.kf.setImage(with: url, options: [.transition(.fade(0.3)), .processor(processor)])
        }
    }

//    var movie: Movie? {
//        didSet {
//
//            if let posterPath = movie?.posterPath {
//                let url = MovieEndpoints.posterImage(path: posterPath).url
//                let processor = RoundCornerImageProcessor(cornerRadius: 40)
//
//                moviePoster.kf.indicatorType = .activity
//                moviePoster.kf.setImage(with: url, options: [.transition(.fade(0.3)), .processor(processor)])
//            }
//        }
//    }
}
