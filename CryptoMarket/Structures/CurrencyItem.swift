//
//  CurrencyItem.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 31/3/22.
//

import Foundation


struct Currency: Decodable {
    
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let rank: Int?
    let is_active: Int
    let first_historical_data: String?
    let last_historical_data: String?
    let platform: Platform?
    
    let property: Property?
    
    enum Property: Decodable {
        case name
        case code
    }
}

extension Currency.Property: CaseIterable { }

extension Currency.Property: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: String) {
        switch rawValue {
        case "Name": self = .name
        case "Code": self = .code
        default: return nil
        }
    }

    var rawValue: String {
        switch self {
        case .name: return "Name"
        case .code: return "Code"
        }
    }

}
