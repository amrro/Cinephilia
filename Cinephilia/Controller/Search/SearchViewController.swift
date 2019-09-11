//
//  SearchViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/10/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    let api = DiscoverAPI()
    var searchController: UISearchController?
    var trending: Trending? {
        didSet { trendingTableView.reloadData() }
    }

    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var trendingTypeSegmentedControl: UISegmentedControl!
    
    @Published var selectedItemIndex: Int?
    @Published var selectedMediaType: DiscoverAPI.MediaType = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        
        _ = $selectedMediaType
            .receive(on: DispatchQueue.main)
            .sink { self.loadTrendingTitles(type: $0) }
        

        _ = $selectedItemIndex
            .filter { $0 != nil }
            .receive(on: DispatchQueue.main)
            .sink { selectedIndex in
                if let mediaItem = self.trending?.results[selectedIndex!] {
                    switch mediaItem {
                    case .movie:
                        self.performSegue(withIdentifier: "openMovieDetails", sender: nil)
                    case .tv:
                        self.performSegue(withIdentifier: "openShowDetails", sender: nil)
                    case .undefined:
                        break
                    }
                }
        }
    }
    
    @IBAction func segmentedControllChanged(_ sender: Any) {
        switch trendingTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedMediaType = .all
            searchController?.searchBar.placeholder = "Search Movies and Shows"
        case 1:
            selectedMediaType = .movie
            searchController?.searchBar.placeholder = "Search Movies"
        case 2:
            selectedMediaType = .tv
            searchController?.searchBar.placeholder = "Search Movies"
        default:
            print("Error happen: segmentedControllChanged(_): Selected selectedSegmentIndex is out of range")
        }
    }
    
    
    private func loadTrendingTitles(type: DiscoverAPI.MediaType) {
        _ = api.trending(type: type)
            .receive(on: DispatchQueue.main)
            .print()
            .sink(receiveCompletion: { (completion) in
                switch completion {

                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }) { self.trending = $0 }
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.becomeFirstResponder()
        searchController?.searchBar.delegate = self
        navigationController?.navigationItem.searchController = searchController
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Movies and Shows"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openMovieDetails", let movieDetailVC = segue.destination as? MovieDetailViewController {
            if let mediaItem = self.trending?.results[selectedItemIndex!] {
                if case let Media.movie(item) = mediaItem {
                    movieDetailVC.movie = item
                }
            }

        }

        if segue.identifier == "openShowDetails", let showDetailVC = segue.destination as? ShowDetailsViewController {
            if let mediaItem = self.trending?.results[selectedItemIndex!] {
                if case let Media.tv(item) = mediaItem {
                    showDetailVC.show = item
                }
            }
        }
    }

}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItemIndex = indexPath.row
    }

}

// MARK: - TableView Data Source
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trending?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedMediaType {
        case .all:
            return "Trending"
        case .movie:
            return "Trending Movies"
        case .tv:
            return "Trending Shows"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell")!
        if let searchCell = cell as? TrendingTableViewCell {
            if let trendingItem = self.trending?.results[indexPath.row] {
                switch trendingItem {
                case .movie(let item):
                    searchCell.itemNameLabel.text = item.originalTitle
                case .tv(let item):
                    searchCell.itemNameLabel.text = item.originalName
                case .undefined:
                    break
                }
            }
        }
        return cell
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
}
