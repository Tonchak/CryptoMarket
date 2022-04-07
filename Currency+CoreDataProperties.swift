//
//  Currency+CoreDataProperties.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 6/4/22.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var identifier: Int16
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var slug: String?
    @NSManaged public var maxSupply: Int16
    @NSManaged public var totalSupply: Double
    @NSManaged public var fullyDilutedMarketCap: Double
    @NSManaged public var price: Double
    @NSManaged public var percentChange1h: Double
    @NSManaged public var percentChange24h: Double
    @NSManaged public var percentChange7d: Double
    @NSManaged public var lastUpdated: String?

}

extension Currency : Identifiable {

}
