//
//  CurrenciesListTableViewController.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 31/3/22.
//

import UIKit

class CurrenciesListTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var items: [ListingLatest] = []
    var filteredItems: [ListingLatest] = []
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CurrencyItemTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = .clear
        self.refreshControl!.tintColor = .secondaryLabel
        self.refreshControl! .addTarget(self, action: #selector(refreshCurrencies), for: .valueChanged)
        tableView .addSubview(self.refreshControl!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search currency"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ListingLatest.Property.allCases.map{$0.rawValue}
        searchController.searchBar.delegate = self
        
        MarketAPIManager.shared.fetchList { items in
            self.items = items
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: -
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func filterContentForSearchText(_ searchText: String, property: ListingLatest.Property? = nil) {

        filteredItems = items.filter { (candy: ListingLatest) -> Bool in let doesCategoryMatch = property == .name || candy.property == property
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
      }

      tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredItems.count
        }
        
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CurrencyItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self), for: indexPath) as! CurrencyItemTableViewCell
        
        cell.currencyItem = items[indexPath.row]
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Actions
    
    @objc func refreshCurrencies()  {
        self.refreshControl!.endRefreshing()
    }
}


extension CurrenciesListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let property = ListingLatest.Property(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

        filterContentForSearchText(searchBar.text!, property: property)
    }
}

extension CurrenciesListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
