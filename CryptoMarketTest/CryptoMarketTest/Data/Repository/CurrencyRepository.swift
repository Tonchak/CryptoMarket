import Foundation

class CurrencyRepository: Repository {
    typealias EntityDTO = CurrencyDTO
    typealias Service = CurrencyServiceProtocol
    
    var dao: QueryDAO
    var service: Service
    
    required init(service: CurrencyServiceProtocol, dao: QueryDAO) {
        self.dao = dao
        self.service = service
    }
    
    func getCurrencies() async throws -> [CurrencyDTO] {
        let cached = try await self.dao.getCurrencies()
        
        guard !cached.isEmpty else {
            let newCurrencies = try await self.service.getCurrencies().currencies
            
            return newCurrencies
        }
        
        return []
    }
}
