import Foundation

struct CurrencyDTO: Identifiable, Hashable, CoreDataStorable, Comparable {
    
    var id: String = UUID().uuidString
        
    var name: String?
    var fullyDilutedMarketCap: Double
    var identifier: Int16
    var lastUpdated: String
    var maxSupply: String
    var percentChange1h: Double
    var percentChange7d: Double
    var percentChange24h: Double
    var price: Double
    var slug: String
    var symbol: String
    var totalSupply: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    init(id: String, name: String? = nil, fullyDilutedMarketCap: Double, identifier: Int16, lastUpdated: String, maxSupply: String, percentChange1h: Double, percentChange7d: Double, percentChange24h: Double, price: Double, slug: String, symbol: String, totalSupply: Double) {
        self.id = id
        self.name = name
        self.fullyDilutedMarketCap = fullyDilutedMarketCap
        self.identifier = identifier
        self.lastUpdated = lastUpdated
        self.maxSupply = maxSupply
        self.percentChange1h = percentChange1h
        self.percentChange7d = percentChange7d
        self.percentChange24h = percentChange24h
        self.price = price
        self.slug = slug
        self.symbol = symbol
        self.totalSupply = totalSupply
    }
    
    static func < (lhs: CurrencyDTO, rhs: CurrencyDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.fullyDilutedMarketCap == rhs.fullyDilutedMarketCap &&
        lhs.identifier == rhs.identifier &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.maxSupply == rhs.maxSupply &&
        lhs.percentChange1h == rhs.percentChange1h &&
        lhs.percentChange7d == rhs.percentChange7d &&
        lhs.percentChange24h == rhs.percentChange24h &&
        lhs.price == rhs.price &&
        lhs.slug == rhs.slug &&
        lhs.symbol == rhs.symbol &&
        lhs.totalSupply == rhs.totalSupply
    }
}

extension CurrencyDTO {
    
}
