//
//  ListingLatest.swift
//  CryptoMarket
//
//  Created by Vitaliy Tonchak on 5/4/22.
//

import Foundation

struct ListingLatest: Decodable {
    
    let id: Int
    let name: String
    let symbol: String?
    let slug: String?
    let num_market_pairs: Int?
    let date_added: String?
    let tags: Array<String>?
    let max_supply: Int?
    let circulating_supply: Double?
    let total_supply: Double?
    let platform: Platform?
    let cmc_rank: Int?
    let self_reported_circulating_supply: Double?
    let self_reported_market_cap: Double?
    let last_updated: String?
    let quote: Quote?
    
    let property: Property?
    
    enum Property: Decodable {
        case name
        case symbol
    }
    
}

extension ListingLatest.Property: CaseIterable { }

extension ListingLatest.Property: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case "Name": self = .name
        case "Code": self = .symbol
        default: return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .name: return "Name"
        case .symbol: return "Code"
        }
    }
    
}

struct Quote: Decodable {
    let USD: USD?
}

struct USD: Decodable {
    let price: Double?
    let volume_24h: Double?
    let volume_change_24h: Double?
    let percent_change_1h: Double?
    let percent_change_24h: Double?
    let percent_change_7d: Double?
    let percent_change_30d: Double?
    let percent_change_60d: Double?
    let percent_change_90d: Double?
    let market_cap: Double?
    let market_cap_dominance: Double?
    let fully_diluted_market_cap: Double?
    let last_updated: String?
}

