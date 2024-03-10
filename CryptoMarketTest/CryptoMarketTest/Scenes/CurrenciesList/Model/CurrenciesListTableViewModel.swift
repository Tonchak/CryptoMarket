import Foundation
import CoreData
import MagicalRecord

final class CurrenciesListTableViewModel {
    var service: DatabaseService = DatabaseServiceImplementation()
    
    func fetchData() {
        Task {
            await _fetchData()
        }
    }
    
    @MainActor internal func _fetchData() async {
        do {
            let response = try await service.fetchCurrenciesList()
            print(response.status as Any)
            guard let data = response.data else { return }
            storeData(data)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension CurrenciesListTableViewModel {
    internal func storeData(_ data: [ListingLatest]) {
        for item in data {
            MagicalRecord.save({ context in
                let predicate = NSPredicate(format: "identifier == %d", item.id)
                var currency = Currency.mr_findFirst(with: predicate, in: context)
                
                if currency == nil {
                    currency = Currency.mr_createEntity(in: context)
                }
                currency?.setValue(Int16(item.id), forKey: "identifier")
                currency?.setValue(item.name, forKey: "name")
                currency?.setValue(item.symbol, forKey: "symbol")
                currency?.setValue(item.slug, forKey: "slug")
                currency?.setValue(item.quote?.USD?.price, forKey: "price")
                currency?.setValue(item.total_supply ?? 0, forKey: "totalSupply")
                currency?.setValue(String(format: "%d", item.max_supply ?? 0), forKey: "maxSupply")
                currency?.setValue((item.quote?.USD?.fully_diluted_market_cap) ?? 0, forKey: "fullyDilutedMarketCap")
                currency?.setValue((item.quote?.USD?.percent_change_1h) ?? 0, forKey: "percentChange1h")
                currency?.setValue((item.quote?.USD?.percent_change_24h) ?? 0, forKey: "percentChange24h")
                currency?.setValue((item.quote?.USD?.percent_change_7d) ?? 0, forKey: "percentChange7d")
            })
        }
    }
}
