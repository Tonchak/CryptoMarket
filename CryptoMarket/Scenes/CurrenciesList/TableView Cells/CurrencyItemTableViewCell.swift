//
//  CurrencyItemTableViewCell.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 31/3/22.
//

import UIKit

class CurrencyItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    private var dataSource: ListingLatest?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CurrencyItemTableViewCell {
    var currencyItem: ListingLatest? {
        get {
            return dataSource
        }
        set (newValue) {
            dataSource = newValue
            currencyCodeLabel.text = dataSource?.symbol
            currencyNameLabel.text = dataSource?.name
            let rateDouble: Double = dataSource?.quote?.USD?.price ?? 0
            exchangeRateLabel.text = String(format: "%f", rateDouble)
        }
    }
}
