import UIKit
import Alamofire

enum NetworkError: Error {
    case badCodeFromResponse(code: Int)
}

final class APIManager {
    
    static let shared = APIManager()
    
    private let rootLink = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    private var afManager: Session
    private var headersApi: HTTPHeaders
    private var defaultDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }
    
    private init() {
        headersApi = ["X-CMC_PRO_API_KEY" : "fcf9bc5e-95f1-489b-92a7-d0be76d78678", "Accept": "application/json"]
        afManager = Alamofire.Session(configuration: URLSessionConfiguration.default)
    }
    
    func fetchList(completionHandler: @escaping (_ items: [ListingLatest]) -> Void) {
        afManager.request(rootLink, headers: headersApi).responseDecodable(of: CurrencyResponse.self) { (response) in
            guard let allCurrencies = response.value else { return }
            completionHandler(allCurrencies.data!)
        }
    }
    
    func requestAPI<T: Decodable>(type: T.Type, method: HTTPMethod = .get, jsonDecoder: JSONDecoder? = nil) async throws -> T {
        let url = makeURL()
        let decoder = jsonDecoder ?? defaultDecoder
        return try await withCheckedThrowingContinuation { continuation in
            afManager.request(url, method: method, headers: headersApi)
                .responseDecodable(of: T.self, decoder: decoder) { response in
                    let code = response.response?.statusCode
                    guard let code, code >= 200, code <= 299 else {
                        continuation.resume(throwing: NetworkError.badCodeFromResponse(code: code ?? .zero))
                        return
                    }
                    
                    switch response.result {
                    case .success(let success):
                        continuation.resume(returning: success)
                    case .failure(let failure):
                        continuation.resume(throwing: failure)
                    }
                }
        }
    }
    
    internal func makeURL() -> URL {
        guard let url = URL(string: rootLink) else {
            return URL(fileURLWithPath: "")
        }
        return url
    }
}

extension APIManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
