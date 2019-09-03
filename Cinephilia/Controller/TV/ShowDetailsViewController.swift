//
//  ShowDetailsViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/2/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    // Mark:- Outlets
    @IBOutlet weak var showBackdropImage: UIImageView!
    @IBOutlet weak var showAiringDateLabel: UILabel!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showGenresLabel: UILabel!
    @IBOutlet weak var showSeasonsCountLabel: UILabel!
    @IBOutlet weak var showOriginalLanguage: UILabel!
    @IBOutlet weak var showAverageRating: UILabel!
    @IBOutlet weak var showOverviewLabel: UILabel!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    
    var show: Show?
    let api = TMDBApi()
    var similarShowDataSource = [Show]() {
        didSet {
            similarCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let it = show {
            updateUI(using: it)
            relaodDetailedShow(with: it.id)
        }
    }
    

    private func updateUI(using show: Show) {
        navigationItem.title = show.name
        navigationItem.largeTitleDisplayMode = .never
        
        // backdrop image.
        let url = ShowsEndpoints.posterPath(path: show.backdropPath!).url
        showBackdropImage.kf.indicatorType = .activity
        showBackdropImage.kf.setImage(with: url)
        
        // show information.
        showAiringDateLabel.text = show.firstAirDate
        showTitleLabel.text = show.originalName
        
        showGenresLabel.text = show.genres?.map{ $0.description }.joined(separator: " | ")
        showSeasonsCountLabel.text = show.seasons?.count.description
        showAverageRating.text = String(show.voteAverage)
        showOverviewLabel.text = show.overview
    }
    
    private func relaodDetailedShow(with id: Int) {
        api.show(with: id)
            .done { (detailedShow) in
                self.updateUI(using: detailedShow)
            }.catch { (error) in
                print(error)
        }
        
        api.similarShows(with: id)
            .done { listing in
                self.similarShowDataSource = listing.results
            }.catch { (error) in
                print(error)
        }
    }
    
    
    private func openSimilarShow(show: Show) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
            vc.show = show
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}


extension ShowDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openSimilarShow(show: similarShowDataSource[indexPath.row])
    }
}


extension ShowDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarShowDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedShowPoster", for: indexPath)
        
        if let posterCell = cell as? SimilarElementCell {
            posterCell.posterPath = similarShowDataSource[indexPath.row].posterPath
        }
        
        return cell
    }
    
    
}
