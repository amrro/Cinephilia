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
    @Published var selectedItemIndex: Int?
    @IBOutlet weak var trendingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()

        _ = api.trending()
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

        _ = $selectedItemIndex
            .filter { $0 != nil }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { selectedIndex in
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

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        navigationController?.navigationItem.searchController = searchController
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Movies, shows..."
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
        return "Trending"
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
