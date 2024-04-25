import Foundation
import CoreData

final class CurrenciesListViewModel {
    
    private let service: DatabaseService?
    var currencyDAO: QueryDAO
    
    private var repository: CurrencyRepository
    
    var result: Box<[CurrencyDTO]?> = Box(nil)
    
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
            let newResult = try await repository.getCurrencies()
            result.value = newResult
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getList() async throws -> [CurrencyDTO] {
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
            
        }
    }
}
