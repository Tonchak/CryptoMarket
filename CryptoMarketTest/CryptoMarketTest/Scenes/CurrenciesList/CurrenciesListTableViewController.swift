import UIKit
import CoreData
import MagicalRecord

class CurrenciesListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var resultsController:SearchCurrenciesResultsController!
    var searchController:UISearchController!
    var items: [ListingLatest] = []
    var filteredItems: [ListingLatest] = []
    var managedContext: NSManagedObjectContext?
    var currencies: [NSManagedObject] = []
    private var persistentContainer = NSPersistentContainer(name: "CryptoMarketTest")
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        
        self.title = "Currencies"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CurrencyItemTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = .clear
        self.refreshControl!.tintColor = .secondaryLabel
        self.refreshControl!.addTarget(self, action: #selector(refreshCurrencies), for: .valueChanged)
        tableView.addSubview(self.refreshControl!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = SearchCurrenciesResultsController.init(style: UITableView.Style.plain)
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search currency"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
        DatabaseHandler.shared.fetchCurrenciesList()
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    private func filterContentForSearchText(searchText: String) {
        let strippedString: String = searchText .trimmingCharacters(in: NSCharacterSet.whitespaces)
        var searchItems: Array<String> = []
        if strippedString.count > 0 {
            searchItems = strippedString .components(separatedBy: NSCharacterSet.whitespaces)
        }
        var andMatchPredicates: Array <NSPredicate> = []
        
        for text in searchItems {
            
            var searchItemsPredicates: Array<NSPredicate> = []
            
            // by name
            let lhs = NSExpression.init(forKeyPath: "name")
            let rhs = NSExpression.init(forConstantValue: text)
            let fPredicate = NSComparisonPredicate.init(leftExpression: lhs, rightExpression: rhs, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.contains, options: NSComparisonPredicate.Options.caseInsensitive)
            searchItemsPredicates.append(fPredicate)
            
            // by code
            let lhsCode = NSExpression.init(forKeyPath: "symbol")
            let rhsCode = NSExpression.init(forConstantValue: text)
            let fPredicateCode = NSComparisonPredicate.init(leftExpression: lhsCode, rightExpression: rhsCode, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.contains, options: NSComparisonPredicate.Options.caseInsensitive)
            searchItemsPredicates.append(fPredicateCode)
            
            let matchPredicates: NSCompoundPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: searchItemsPredicates)
            andMatchPredicates.append(matchPredicates)
        }
        
        let finalCompoundPredicate: NSCompoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: andMatchPredicates)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        let entity: NSEntityDescription = Currency.mr_entityDescription(in: NSManagedObjectContext.mr_default())!
        let sortDescriptors: Array<NSSortDescriptor> = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        fetchRequest.entity = entity
        fetchRequest.predicate = finalCompoundPredicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.mr_default(), sectionNameKeyPath: nil, cacheName: nil)
        resultsController.searchFetchedResultsController = frc
        resultsController.searchFetchedResultsController.delegate = resultsController
        
        do {
            try resultsController.searchFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        resultsController.tableView.reloadData()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self), for: indexPath) as? CurrencyItemTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let item: Currency = fetchedResultsController.object(at: indexPath)
        cell.dataModel = CMTableViewCellDataModel.initWith(entity: item)
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = CurrencyDetailViewController.init(nibName: "CurrencyDetailViewController", bundle: nil)
        
        let item: Currency = fetchedResultsController.object(at: indexPath)
        controller.dataModel = CMTableViewCellDataModel.dataModelWith(entity: item)
        
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {}
    
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
    
    @objc func refreshCurrencies()  {
        DatabaseHandler.shared.updateList {
            DispatchQueue.main.async {
                self.refreshControl!.endRefreshing()
            }
        }
    }
}

extension CurrenciesListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text ?? "")
    }
}

// MARK: - UISearchBarDelegate

extension CurrenciesListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
