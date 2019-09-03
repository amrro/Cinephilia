//
//  TVShowTableViewCell.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/2/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var numberOfSeasonsLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
    
    var show: Show?  {
        didSet {
            if let it = show {
                updateUI(with: it)
            }
        }
    }
    
    private func updateUI(with show: Show) {
        let url: URL = ShowsEndpoints.posterPath(path: show.posterPath).url
        let roundProcessor = RoundCornerImageProcessor(cornerRadius: 40)
        
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.3)), .processor(roundProcessor)])
        
        ratingLabel.text = "Rating: \(show.voteAverage)"
        showNameLabel.text = show.originalName
        airDateLabel.text = show.firstAirDate
        
    }

}
