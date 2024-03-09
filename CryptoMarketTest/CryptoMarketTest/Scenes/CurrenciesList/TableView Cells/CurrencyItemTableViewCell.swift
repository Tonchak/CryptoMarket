import UIKit

class CurrencyItemTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    private var dataSource: ListingLatest?
    private var _dataModel: CMTableViewCellDataModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CurrencyItemTableViewCell {
    var dataModel: CMTableViewCellDataModel? {
        get {
            return _dataModel
        }
        set (newValue) {
            _dataModel = newValue
            currencyCodeLabel.text = _dataModel?.code
            currencyNameLabel.text = _dataModel?.name
            exchangeRateLabel.text = _dataModel?.rateText
        }
    }
}
