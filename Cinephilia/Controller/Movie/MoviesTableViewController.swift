//
//  HomeViewControlerTableViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/26/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {
    
    private let api = MoviesAPI()
    
    private var fetchedMovies = [Movie]() {
        didSet {
            currentDataSource = fetchedMovies
            tableView.reloadData()
        }
    }
    
    private var currentDataSource = [Movie]() {
        didSet { tableView.reloadData() }
    }
    
    private var sorting: Sorting = .popular {
        didSet {
            tableView.refreshControl?.beginRefreshing()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var selectedMovieIndex = 0 {
        didSet {
            performSegue(withIdentifier: "showMovieDetail", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        setupRefreshConroller()
        
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl?.beginRefreshing()
        loadMovies()
    }
    
    private func setupRefreshConroller() {
        if  tableView.refreshControl == nil {
            tableView.refreshControl = UIRefreshControl()
        }
        
        tableView.refreshControl?.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
    }
    
    @objc
    private func loadMovies() {
        api.movies(sorting: sorting)
            .done({ listing in
                self.fetchedMovies = listing.results
                self.tableView.refreshControl?.endRefreshing()
            })
            .catch { (error) in
                print(error)
        }
    }
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        
        if let movieCell = cell as? MovieTableViewCell {
            movieCell.movie = currentDataSource[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovieIndex = indexPath.row
    }
    
    
    // MARK: - Navigations
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let movieDetailVC = segue.destination as? MovieDetailViewController {
                movieDetailVC.movie = self.currentDataSource[selectedMovieIndex]
            }
        }
    }
    
    
}


extension MoviesTableViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            self.api.search(query: query)
                .get { (listing: Listing<Movie>) in
                    self.currentDataSource = listing.results
                    self.tableView.reloadData()
                }.catch { (error) in
                    print(error)
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentDataSource = fetchedMovies
    }
    
}
