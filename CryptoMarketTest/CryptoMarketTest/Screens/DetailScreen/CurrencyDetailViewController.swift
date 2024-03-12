import UIKit

class CurrencyDetailViewController: UIViewController {
    
    var dataModel: CMTableViewCellDataModel?
    var models: [DetailItem]?
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var availableCoinsLabel: UILabel!
    @IBOutlet weak var maxAvailabelCoinsLabel: UILabel!
    @IBOutlet weak var totalMarketCapitalizationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataModel?.code
        
        mainTitleLabel.text = dataModel?.name
        
        let totalCoins: Double = dataModel?.totalSupply ?? 0
        let totalCapitalization: Double = dataModel?.totalMarketCap ?? 0
        
        rateLabel.text = dataModel?.rateText
        availableCoinsLabel.text = String(format: "%f", totalCoins)
        maxAvailabelCoinsLabel.text = dataModel?.maxSupplyText
        totalMarketCapitalizationLabel.text = String(format: "%f", totalCapitalization)
        
        //
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(DetailTableViewCell.self))
        
        models = dataModel?.models
    }
}

extension CurrencyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(DetailTableViewCell.self), for: indexPath) as? DetailTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.dataModel = models?[indexPath.row]
        
        return cell
    }
}

extension CurrencyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Percent changes to:"
    }
}
