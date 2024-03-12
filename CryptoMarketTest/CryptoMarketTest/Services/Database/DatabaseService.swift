import Foundation

protocol DatabaseService: Actor, Sendable {
    var items: [ListingLatest]? { get set }
    
    func fetchCurrenciesList() async throws -> CurrencyResponse
}

extension DatabaseService {
    func fetchCurrenciesList() async throws -> CurrencyResponse {
        throw DatabaseError.readingError("--")
    }
}
