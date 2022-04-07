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
    
    // MARK: - Init
    
    class func initWith(entity: Currency) -> CMTableViewCellDataModel {
        let model: CMTableViewCellDataModel = CMTableViewCellDataModel()
        
        model.currencyEntity = entity
        model.code = entity.symbol
        model.name = entity.name
        model.rate = entity.price
        model.rateText = String(format: "%f", entity.price)
        
        return model
    }
    
}
