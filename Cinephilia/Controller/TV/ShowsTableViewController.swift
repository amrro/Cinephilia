//
//  TVShowsTableViewController.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 9/2/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import UIKit

class ShowsTableViewController: UITableViewController {
    
    private let api = ShowsAPI()
    private var fetchedShows = [Show]() {
        didSet { tableView.reloadData() }
    }
    
    private var selecedIndex: Int = 0 {
        didSet {
            performSegue(withIdentifier: "showDetails", sender: nil)
        }
    }
    
    private var sorting: Sorting = .popular {
        didSet {
            loadShows()
            navigationController?.navigationBar.topItem?.title = sorting.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sorting = .popular
    }
    
    @IBAction func updateSorting(_ sender: Any) {
        let sortingActionSheet = UIAlertController(title: "Select Sorting Type.", message: nil, preferredStyle: .actionSheet)
        
        for sortingItem in Sorting.values {
            sortingActionSheet.addAction(
                UIAlertAction(title: sortingItem.rawValue, style: .default, handler: { [weak self] (UIAlertAction) in
                    if sortingItem != self?.sorting {
                        self?.sorting = sortingItem
                    }
                }))
        }
        
        sortingActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(sortingActionSheet, animated: true, completion: nil)
    }
    
    
    private func loadShows() {
        api.shows(with: sorting)
            .done { (listing: Listing<Show>) in
                self.fetchedShows = listing.results
            }.catch { (error) in
                print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedShows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTableViewCell", for: indexPath)
        
        if let showCell = cell as? TVShowTableViewCell {
            showCell.show = self.fetchedShows[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selecedIndex = indexPath.row
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let detailVC = segue.destination as? ShowDetailsViewController {
                detailVC.show = fetchedShows[selecedIndex]
            }
        }
    }


}
