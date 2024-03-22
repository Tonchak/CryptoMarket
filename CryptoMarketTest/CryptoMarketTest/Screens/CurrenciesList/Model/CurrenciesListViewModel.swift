import Foundation
import CoreData
import MagicalRecord

final class CurrenciesListViewModel {
    
    private let service: DatabaseService?
    var currencyDAO: QueryDAO
    
    private var repository: CurrencyRepository
    
    init(service: DatabaseService? = DatabaseServiceImplementation(),
         currencyDAO: QueryDAO = CurrencyDAO(),
         repository: CurrencyRepository = DependencyInjector.getCurrencyRepositiry()) {
        self.service = service
        self.currencyDAO = currencyDAO
        self.repository = repository
    }
    
    func fetchData() {
        Task {
            //await _fetchData()
            await _retrieveList()
        }
    }
    
    @MainActor internal func _fetchData() async {
        guard let service = service else { return }
        
        do {
            let response = try await service.fetchCurrenciesList()
            guard let data = response.data else { return }
            //storeData(data)
            try await saveData(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor internal func _retrieveList() async {
        do {
            let result = try await repository.getCurrencies()
            print(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getList() async throws -> [Currency] {
        try await currencyDAO.getCurrencies()
    }
}

extension CurrenciesListViewModel {
    internal func saveData(_ data: [ListingLatest]) async throws {
        async let currencies = try currencyDAO.addCurrencies(data)
        _ = try await currencies
    }
}

extension CurrenciesListViewModel {
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
