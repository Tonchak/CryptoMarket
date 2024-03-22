import Foundation

struct DependencyInjector {
    static func getCurrencyRepositiry() -> CurrencyRepository {
        return CurrencyRepository(service: CurrencyService(), dao: CurrencyDAO())
    }
}
