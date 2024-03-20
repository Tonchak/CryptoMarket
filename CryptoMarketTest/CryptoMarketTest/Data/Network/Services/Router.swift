import Foundation

enum CMRouter: Equatable {
    case listingLatest
    
    var url: String {scheme + "://" + host + path}
    var scheme: String {API.scheme}
    var host: String {API.URL}
    
    var path: String {
        switch self {
        case .listingLatest:
            return "/listings/latest"
        }
    }
    
    var method: String {
        switch self {
        case .listingLatest:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .listingLatest:
            return [
                URLQueryItem(name: "X-CMC_PRO_API_KEY", value: API.privateKey)
                //URLQueryItem(name: "Accept", value: "application/json")
            ]
        }
    }
}

struct API {
    static var privateKey: String { "fcf9bc5e-95f1-489b-92a7-d0be76d78678" }
    static var schemeURL: String {scheme + "://" + URL}
    static var scheme: String { return "https" }
    static var URL: String { 
        "pro-api.coinmarketcap.com/v1/cryptocurrency"
    }
}
