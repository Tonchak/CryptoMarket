import Foundation

protocol DatabaseService: Actor, Sendable {
    var items: [ListingLatest]? { get set }
    
    func fetchCurrenciesList() async throws -> CurrencyResponse
}
