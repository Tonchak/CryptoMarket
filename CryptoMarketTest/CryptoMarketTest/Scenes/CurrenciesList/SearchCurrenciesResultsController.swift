import UIKit
import MagicalRecord

class SearchCurrenciesResultsController: UITableViewController {
    
    var searchFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func loadView() {
        super.loadView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CurrencyItemTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currencies = searchFetchedResultsController.fetchedObjects else {
            return 0
        }
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CurrencyItemTableViewCell.self), for: indexPath) as? CurrencyItemTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let item: Currency = searchFetchedResultsController.object(at: indexPath) as! Currency
        cell.dataModel = CMTableViewCellDataModel.initWith(entity: item)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = CurrencyDetailViewController.init(nibName: "CurrencyDetailViewController", bundle: nil)
        
        let item: Currency = searchFetchedResultsController.object(at: indexPath) as! Currency
        controller.dataModel = CMTableViewCellDataModel.dataModelWith(entity: item)
        
        self.presentingViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchCurrenciesResultsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
