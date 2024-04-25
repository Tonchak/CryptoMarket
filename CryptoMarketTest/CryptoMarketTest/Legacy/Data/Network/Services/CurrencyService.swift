import Foundation

protocol CurrencyServiceProtocol {
    func getCurrencies() async throws -> CurrencyResponseDTO
}

struct CurrencyService: HTTPClient, CurrencyServiceProtocol {
    func getCurrencies() async throws -> CurrencyResponseDTO {
        return try await executeRequest(endpoint: .listingLatest, responseModel: CurrencyResponseDTO.self)
    }
}
