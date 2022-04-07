//
//  CMTableViewCellDataModel.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 7/4/22.
//

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
        
        return model
    }
}
