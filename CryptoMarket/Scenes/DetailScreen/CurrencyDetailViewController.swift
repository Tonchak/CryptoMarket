//
//  CurrencyDetailViewController.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 5/4/22.
//

import UIKit

class CurrencyDetailViewController: UIViewController {
    
    var dataSource: ListingLatest?
    var dataModel: CMTableViewCellDataModel?
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var availableCoinsLabel: UILabel!
    @IBOutlet weak var maxAvailabelCoinsLabel: UILabel!
    @IBOutlet weak var totalMarketCapitalizationLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataSource?.symbol
        
        mainTitleLabel.text = dataModel?.name
        
        let totalCoins: Double = dataModel?.totalSupply ?? 0
        let totalCapitalization: Double = dataModel?.totalMarketCap ?? 0
        
        rateLabel.text = dataModel?.rateText
        availableCoinsLabel.text = String(format: "%f", totalCoins)
        maxAvailabelCoinsLabel.text = dataModel?.maxSupplyText
        totalMarketCapitalizationLabel.text = String(format: "%f", totalCapitalization)
        
    }

}
