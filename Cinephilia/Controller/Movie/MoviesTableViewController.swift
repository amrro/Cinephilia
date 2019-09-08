//
//  HomeViewControlerTableViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/26/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Combine

class MoviesTableViewController: UITableViewController {
    
    private let api = MoviesAPI()
    let searchController = UISearchController(searchResultsController: nil)

    private var fetchedMovies = [Movie]() {
        didSet { currentDataSource = fetchedMovies }
    }
    
    private var currentDataSource = [Movie]() {
        didSet { tableView.reloadData() }
    }
    
    @Published private var sorting: Sorting = .popular
    @Published private var selectedMovieIndex: Int! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupRefreshConroller()
        setupSearchController()
        
        let _ = $sorting
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .print()
            .sink { sorting in
                self.loadMovies()
                self.navigationController?.navigationBar.topItem?.title = sorting.rawValue
        }
        
        let _ = $selectedMovieIndex.filter{ $0 != nil }
            .receive(on: DispatchQueue.main)
            .print()
            .sink { _ in self.performSegue(withIdentifier: "showMovieDetail", sender: nil) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sorting = .popular
    }
    
    @IBAction func sortMovies(_ sender: Any) {
        let sortingActionSheet = UIAlertController(title: "Select Sorting Type", message: nil, preferredStyle: .actionSheet)
        
        for sortingItem in Sorting.values {
            sortingActionSheet.addAction(
                UIAlertAction(title: sortingItem.rawValue, style: .default, handler: { [weak self] (alerAction) in
                    self?.sorting = sortingItem
                })
            )
        }

        sortingActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sortingActionSheet, animated: true, completion: nil)
    }
    

    
    private func setupRefreshConroller() {
        if  tableView.refreshControl == nil {
            tableView.refreshControl = UIRefreshControl()
        }
        
        tableView.refreshControl?.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
    }
    
    fileprivate func setupSearchController() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func loadMovies() {
        self.tableView.refreshControl?.beginRefreshing()
        
        let _ = api.movies(sorting: sorting)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                self.tableView.refreshControl?.endRefreshing()
                
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break;
                }
            }) { self.fetchedMovies = $0.results }
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
            let _ = self.api.search(query: query)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (comletion) in
                    switch comletion {
                    case .finished:
                        break;
                    case .failure(let error):
                        print(error)
                    }
                }) { listing in
                    self.currentDataSource = listing.results
                    self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentDataSource = fetchedMovies
    }
    
}
