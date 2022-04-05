//
//  MarketAPIManager.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 4/4/22.
//

import UIKit
import Alamofire

class MarketAPIManager: NSObject {

    static let shared: MarketAPIManager = MarketAPIManager()
    
    private var afManager: Session = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private let rootLink: String = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    
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
    
    func fetchCurrenciesList() -> Array<Any> {
        return Array.init()
    }
    
    // MARK: - Private workflow
    
    func fetchAPIWithRequest(request: URLRequest,  closure: () -> Void ) {
        
    }
    
}
