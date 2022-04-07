//
//  CurrenciesListTableViewController.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 31/3/22.
//

import UIKit
import CoreData
import MagicalRecord

class CurrenciesListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var items: [ListingLatest] = []
    var filteredItems: [ListingLatest] = []
    
    var managedContext: NSManagedObjectContext?
    private var persistentContainer = NSPersistentContainer(name: "CryptoMarket")
    var currencies: [NSManagedObject] = []

    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        
        self.title = "Currencies"
        
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
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            
            if let error = error {
                
                print("\(error), \(error.localizedDescription)")
                
            } else {
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        DatabaseHandler.shared.fetchCurrenciesList { error in
            
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                Swift.print(fetchError)
            }
            
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
        
        guard let currencies = fetchedResultsController.fetchedObjects else {
            return 0
        }
        
        if isFiltering {
            return filteredItems.count
        }
        
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CurrencyItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self), for: indexPath) as! CurrencyItemTableViewCell
        
        //cell.currencyItem = items[indexPath.row]
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = CurrencyDetailViewController.init(nibName: "CurrencyDetailViewController", bundle: nil)
        
        if items.count > 0 {
            controller.dataSource = items[indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Currency> = {
        
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: NSManagedObjectContext.mr_default(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.automatic)
        case .move: do {
            self.tableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.automatic)
            self.tableView.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.fade)
        }
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    // MARK: - Actions
    
    @objc func refreshCurrencies()  {
        MarketAPIManager.shared.fetchList { items in
            self.refreshControl!.endRefreshing()
            self.items = items
            self.tableView.reloadData()
        }
    }
}


extension CurrenciesListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let property = ListingLatest.Property(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

        filterContentForSearchText(searchBar.text!, property: property)
    }
}

// MARK: - UISearchBarDelegate

extension CurrenciesListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

