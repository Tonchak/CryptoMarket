import Foundation

struct Platform: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let token_address: String
}
