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
    //@Backed() var quote: Quote?
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    static func < (lhs: CurrencyDTO, rhs: CurrencyDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}

extension CurrencyDTO {
    
}
