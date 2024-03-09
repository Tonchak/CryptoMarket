import UIKit
import Alamofire

class MarketAPIManager {
    private var afManager: Session = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private let rootLink: String = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    
    static let shared: MarketAPIManager = {
        let instance = MarketAPIManager()
        return instance
    }()
    
    private init() {}
    
    func fetchList(completionHandler: @escaping (_ items: Array<ListingLatest>) -> Void) {
        
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY" : "fcf9bc5e-95f1-489b-92a7-d0be76d78678",
            "Accept": "application/json"
        ]
        
        AF.request(rootLink, headers: headers).responseDecodable(of: CurrencyResponse.self) { (response) in
            guard let allCurrencies = response.value else { return }
            completionHandler(allCurrencies.data!)
        }
    }
}

extension MarketAPIManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
