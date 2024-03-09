import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var _dataModel: DetailItem?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DetailTableViewCell {
    var dataModel: DetailItem? {
        get {
            return _dataModel
        }
        set (newValue) {
            _dataModel = newValue
            
            mainTitleLabel.text = _dataModel?.mainTitle
            descriptionLabel.text = _dataModel?.text
            descriptionLabel.textColor = _dataModel?.color
            
        }
    }
}
