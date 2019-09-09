//
//  MovieDetailViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/26/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    var movie: Movie?
    private let api = MoviesAPI()
    
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var movietitleLabel: UILabel!
    @IBOutlet weak var movieGeneresLabel: UILabel!
    @IBOutlet weak var movieLengthLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    
    // Related Movies.
    @IBOutlet weak var similarMoviesHeadline: UILabel!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    var similarMoviesDataSource: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            updateUI(using: movie)
        }
        reloadMovie()
        setupNavBar()
    }
    
    private func reloadMovie() {
        guard movie != nil else { return }
        
        let _ = api.movie(with: movie!.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                    break;
                case .failure(let error):
                    print(error)
                }
            }) { self.updateUI(using: $0) }
        
        
        let _ = api.similarMovies(with: movie!.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let error):
                    print(error)
                }
            }) {
                self.updateCollectionView(listing: $0)
        }
    }
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.
        let navBarAppearance = navigationController?.navigationBar.standardAppearance.copy()
        
    }
    
    private func updateUI(using newMovie: Movie) {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = newMovie.originalTitle
        
        movieReleaseDate.text = newMovie.releaseDate
        movietitleLabel.text = newMovie.originalTitle
        movieLanguageLabel.text = newMovie.originalLanguage.description
        movieRatingLabel.text = "\(newMovie.voteAverage)"
        // Backdrop
        if let backdropPath = movie?.backdropPath {
            let url = MovieEndpoints.posterImage(path: backdropPath).url
            
            backdropImageView.kf.indicatorType = .activity
            backdropImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        }
        
        movieGeneresLabel.text = newMovie.genres?.map { $0.description }.joined(separator: " | ")
        movieLengthLabel.text = "\(newMovie.runtime ?? 0) mins"
        movieOverviewLabel.text = newMovie.overview
    }
    
    
    private func updateCollectionView(listing: Listing<Movie>) {
        if (listing.results.isEmpty) {
            similarMoviesHeadline.isHidden = true
            similarMoviesCollectionView.isHidden = true
        } else {
            similarMoviesHeadline.isHidden = false
            similarMoviesCollectionView.isHidden = false
        }
        
        similarMoviesDataSource = listing.results
        similarMoviesCollectionView.reloadData()
    }
    
    
    private func openSimilarMovie(movie: Movie)  {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.movie = movie
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}


// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = similarMoviesDataSource[indexPath.row]
        openSimilarMovie(movie: movie)
    }
    
}


// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMoviesDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedMoviePoster", for: indexPath)
        let movie = similarMoviesDataSource[indexPath.row]
        if let posterCell = cell as? SimilarElementCell {
            posterCell.posterPath = movie.posterPath
        }
        return cell
    }
}
