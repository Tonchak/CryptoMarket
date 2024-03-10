import Foundation

struct Platform: Decodable {
    let id: Int?
    let name: String?
    let symbol: String?
    let slug: String?
    let token_address: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case slug
        case token_address
    }
    
    
    init(id: Int?, name: String?, symbol: String?, slug: String?, token_address: String?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.slug = slug
        self.token_address = token_address
    }
}
