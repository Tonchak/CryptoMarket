import UIKit
import CoreData

class CMTableViewCellDataModel: NSObject {
    var currencyEntity: Currency?
    var code: String?
    var name: String?
    var rate: Double?
    var rateText: String?
    var totalSupply: Double?
    var maxSupplyText: String?
    var totalMarketCap: Double?
    var models: Array<DetailItem>?
    
    // MARK: - Init
    
    class func initWith(entity: Currency) -> CMTableViewCellDataModel {
        let model: CMTableViewCellDataModel = CMTableViewCellDataModel()
        
        model.code = entity.symbol
        model.name = entity.name
        model.rate = entity.price
        model.rateText = String(format: "%f", entity.price)
        
        return model
    }
    
    class func dataModelWith(entity: Currency) -> CMTableViewCellDataModel {
        
        let model: CMTableViewCellDataModel = CMTableViewCellDataModel()
        
        model.code = entity.symbol
        model.name = entity.name
        model.rate = entity.price
        model.rateText = String(format: "%f", entity.price)
        model.totalSupply = entity.totalSupply
        model.maxSupplyText = entity.maxSupply
        model.totalMarketCap = entity.fullyDilutedMarketCap
        
        let last1h: DetailItem = DetailItem(
            mainTitle: "Last 1h",
            text: String(format: "%f", entity.percentChange1h),
            color: entity.percentChange1h > 0 ? .green : .red
        )
        let last24h: DetailItem = DetailItem(
            mainTitle: "Last 24h",
            text: String(format: "%f", entity.percentChange24h),
            color: entity.percentChange24h > 0 ? .green : .red
        )
        let last7d: DetailItem = DetailItem(
            mainTitle: "Last 7d",
            text: String(format: "%f", entity.percentChange7d),
            color: entity.percentChange24h > 0 ? .green : .red
        )
        
        model.models = [last1h, last24h, last7d]
        
        return model
    }
}
