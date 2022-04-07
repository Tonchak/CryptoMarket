//
//  DatabaseHandler.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 6/4/22.
//

import UIKit
import CoreData
import MagicalRecord

class DatabaseHandler: NSObject {

    var items: [ListingLatest] = []
    
    static let shared: DatabaseHandler = DatabaseHandler()
    
    public func fetchCurrenciesList() {
        fetchListWith { items in
            self.models = items
        }
    }
    
    public func updateList(completionBlock: @escaping () -> Void) {
        fetchListWith { items in
            self.models = items
            completionBlock()
        }
    }
    
    // MARK: -
    
    private func fetchListWith(block: @escaping (_ items: Array<ListingLatest>) -> Void ) {
        MarketAPIManager.shared.fetchList { items in
            block(items)
        }
    }
    
}

extension DatabaseHandler {
    var models: [ListingLatest]? {
        get {
            return items
        }
        set (newValue) {
            items = newValue!
            
            for item in self.items {
                
                MagicalRecord.save({ context in
                    
                    let predicate = NSPredicate(format: "identifier == %d", item.id)
                    
                    var currency = Currency.mr_findFirst(with: predicate, in: context)

                    if currency == nil {
                        currency = Currency.mr_createEntity(in: context)
                    }
                    
                    currency?.identifier = Int16(item.id)
                    currency?.name = item.name
                    currency?.symbol = item.symbol
                    currency?.slug = item.slug
                    currency?.price = (item.quote?.USD?.price) ?? 0
                    currency?.totalSupply = item.total_supply ?? 0
                    currency?.maxSupply = String(format: "%d", item.max_supply ?? 0)
                    currency?.fullyDilutedMarketCap = (item.quote?.USD?.fully_diluted_market_cap) ?? 0
                    currency?.percentChange1h = (item.quote?.USD?.percent_change_1h) ?? 0
                    currency?.percentChange24h = (item.quote?.USD?.percent_change_24h) ?? 0
                    currency?.percentChange7d = (item.quote?.USD?.percent_change_7d) ?? 0
                    
                })
            }
            
        }
    }
}
