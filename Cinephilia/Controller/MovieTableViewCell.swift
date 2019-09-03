//
//  MovieTableViewCell.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/26/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var averageVotingLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            if let it = movie {
                populateData(using: it)
            }
        }
    }
    
    private func populateData(using movie: Movie) {
        movieTitleLabel?.text = movie.originalTitle
        releaseDateLabel?.text = movie.releaseDate
        averageVotingLabel.text = "Rating: \(movie.voteAverage)"
        
        if let posterPath = movie.posterPath {
            let url = MovieEndpoints.posterImage(path: posterPath).url
            let processor = RoundCornerImageProcessor(cornerRadius: 40)
            
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.3)), .processor(processor)])
        }
    }
}
