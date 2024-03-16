import Foundation
import CoreData

protocol QueryDAO: CoreDataDAO<Currency> {
    @discardableResult
    func addCurrencies(_ data: [ListingLatest]) async throws -> [Currency]
    func getCurrencies() throws -> [Currency]
}

final class CurrencyDAO: CoreDataDAO<Currency>, QueryDAO {
    
    @discardableResult
    func addCurrencies(_ data: [ListingLatest]) async throws -> [Currency] {
        let context = storage.mainContext
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    
                    let currencies = (data).map {
                        let curr = self.addCurrency(from: $0, to: context)
                        return curr
                    }
                    
                    try self.storage.saveContext()
                    continuation.resume(returning: currencies)
                } catch {
                    context.reset()
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCurrencies() throws -> [Currency] {
        try self.getEntities()
    }
}

extension CurrencyDAO {
    internal func addCurrency(from rawData: ListingLatest, to moc: NSManagedObjectContext) -> Currency {
        let currency = Currency(context: moc)
        currency.identifier = Int16(rawData.id)
        currency.name = rawData.name
        currency.symbol = rawData.symbol
        currency.slug = rawData.slug
        currency.price = rawData.quote?.USD?.price ?? 0
        currency.totalSupply = rawData.total_supply ?? 0
        currency.maxSupply = String(format: "%d", rawData.max_supply ?? 0)
        currency.fullyDilutedMarketCap = rawData.quote?.USD?.fully_diluted_market_cap ?? 0
        currency.percentChange1h = rawData.quote?.USD?.percent_change_1h ?? 0
        currency.percentChange24h = rawData.quote?.USD?.percent_change_24h ?? 0
        currency.percentChange7d = rawData.quote?.USD?.percent_change_7d ?? 0
        return currency
    }
}
