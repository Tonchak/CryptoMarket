import Foundation

struct ListingLatest: Decodable {
    let id: Int
    let name: String
    let symbol: String?
    let slug: String?
    let num_market_pairs: Int?
    let date_added: String?
    let tags: [String]?
    let max_supply: Double?
    let circulating_supply: Double?
    let total_supply: Double?
    let infinite_supply: Bool
    let platform: Platform?
    let cmc_rank: Int?
    let self_reported_circulating_supply: Double?
    let self_reported_market_cap: Double?
    let tvl_ratio: Double?
    let last_updated: String?
    let quote: Quote?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case slug
        case num_market_pairs
        case date_added
        case tags
        case max_supply
        case circulating_supply
        case total_supply
        case infinite_supply
        case platform
        case cmc_rank
        case self_reported_circulating_supply
        case self_reported_market_cap
        case tvl_ratio
        case last_updated
        case quote
    }
    
    init(id: Int, name: String, symbol: String?, slug: String?, num_market_pairs: Int?, date_added: String?, tags: [String]?, max_supply: Double?, circulating_supply: Double?, total_supply: Double?, infinite_supply: Bool, platform: Platform?, cmc_rank: Int?, self_reported_circulating_supply: Double?, self_reported_market_cap: Double?, tvl_ratio: Double?, last_updated: String?, quote: Quote?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.slug = slug
        self.num_market_pairs = num_market_pairs
        self.date_added = date_added
        self.tags = tags
        self.max_supply = max_supply
        self.circulating_supply = circulating_supply
        self.total_supply = total_supply
        self.infinite_supply = infinite_supply
        self.platform = platform
        self.cmc_rank = cmc_rank
        self.self_reported_circulating_supply = self_reported_circulating_supply
        self.self_reported_market_cap = self_reported_market_cap
        self.tvl_ratio = tvl_ratio
        self.last_updated = last_updated
        self.quote = quote
    }
    
//    let property: Property?
//    
//    enum Property: Decodable {
//        case name
//        case symbol
//    }
}

//extension ListingLatest.Property: CaseIterable {
//    
//}

//extension ListingLatest.Property: RawRepresentable {
//    typealias RawValue = String
//    
//    init?(rawValue: String) {
//        switch rawValue {
//        case "Name": self = .name
//        case "Code": self = .symbol
//        default: return nil
//        }
//    }
//    
//    var rawValue: String {
//        switch self {
//        case .name: return "Name"
//        case .symbol: return "Code"
//        }
//    }
//}

struct Quote: Decodable {
    let USD: USD?
    
    enum CodingKeys: String, CodingKey {
        case USD
    }
    
    init(USD: USD?) {
        self.USD = USD
    }
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
    let tvl: Double?
    let last_updated: String?
    
    enum CodingKeys: String, CodingKey {
        case price
        case volume_24h
        case volume_change_24h
        case percent_change_1h
        case percent_change_24h
        case percent_change_7d
        case percent_change_30d
        case percent_change_60d
        case percent_change_90d
        case market_cap
        case market_cap_dominance
        case fully_diluted_market_cap
        case tvl
        case last_updated
    }
}
