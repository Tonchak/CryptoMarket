import Foundation

final actor DatabaseServiceImplementation: DatabaseService {
    var items: [ListingLatest]?
    
    init(items: [ListingLatest]? = []) {
        self.items = items
    }
    
    func fetchCurrenciesList() async throws -> CurrencyResponse {
        try await APIManager.shared.requestAPI(type: CurrencyResponse.self)
    }
    
}
