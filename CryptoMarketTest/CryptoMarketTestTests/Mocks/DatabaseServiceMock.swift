import Foundation
@testable import CryptoMarketTest

final actor DatabaseServiceMock: DatabaseService {
    var items: [CryptoMarketTest.ListingLatest]?
    
    func fetchCurrenciesList() async throws -> CryptoMarketTest.CurrencyResponse {
        guard let json = CryptoMarketTest.CurrencyResponse.DataSamples.successfull else {
            throw CryptoMarketTest.NetworkError.badCodeFromResponse(code: 1001)
        }
        
        do {
            let response = try JSONDecoder().decode(CryptoMarketTest.CurrencyResponse.self, from: json)
            return response
        } catch {
            return CryptoMarketTest.CurrencyResponse.init(status: nil)
        }
    }
}
