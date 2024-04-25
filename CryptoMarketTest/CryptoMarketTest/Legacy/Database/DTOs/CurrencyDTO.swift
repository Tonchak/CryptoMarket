import Foundation
import BackedCodable

struct CurrencyDTO: BackedDecodable, Identifiable, Hashable, CoreDataStorable, Comparable {
    
    var id: String = UUID().uuidString
    
    init(_: DeferredDecoder) {
    }
    
    @Backed() var name: String?
    @Backed() var symbol: String
    @Backed() var slug: String
    @Backed() var num_market_pairs: Double
    @Backed() var date_added: String
    @Backed() var max_supply: Double?
    @Backed() var circulating_supply: Double?
    @Backed() var total_supply: Double?
    @Backed() var infinite_supply: Bool
    @Backed() var cmc_rank: Int?
    @Backed() var self_reported_circulating_supply: Double?
    @Backed() var self_reported_market_cap: Double?
    @Backed() var tvl_ratio: Double?
    @Backed() var last_updated: String?
    @Backed(Path("quote", "USD")) var quote: QuoteDTO
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    static func < (lhs: CurrencyDTO, rhs: CurrencyDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}

extension CurrencyDTO {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(quote)
    }
}

struct QuoteDTO: Codable, Hashable {
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
