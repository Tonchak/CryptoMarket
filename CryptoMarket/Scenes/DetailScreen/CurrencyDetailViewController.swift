//
//  CurrencyDetailViewController.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 5/4/22.
//

import UIKit

class CurrencyDetailViewController: UIViewController {
    
    var dataSource: ListingLatest?
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var availableCoinsLabel: UILabel!
    @IBOutlet weak var maxAvailabelCoinsLabel: UILabel!
    @IBOutlet weak var totalMarketCapitalizationLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataSource?.symbol
        
        mainTitleLabel.text = dataSource?.name
        
        let rateDouble: Double = dataSource?.quote?.USD?.price ?? 0
        let totalCoins: Double = dataSource?.total_supply ?? 0
        let maxCoins: Int = dataSource?.max_supply ?? 0
        let totalCapitalization: Double = dataSource?.quote?.USD?.fully_diluted_market_cap ?? 0
        
        rateLabel.text = String(format: "%f", rateDouble)
        availableCoinsLabel.text = String(format: "%f", totalCoins)
        maxAvailabelCoinsLabel.text = String(format: "%d", maxCoins)
        totalMarketCapitalizationLabel.text = String(format: "%f", totalCapitalization)
        
    }

}
