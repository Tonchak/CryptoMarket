import Foundation

struct CurrencyResponse: Decodable {
    
    let status: Status?
    var data: [ListingLatest]?
    
    init(status: Status?, data: [ListingLatest]? = nil) {
        self.status = status
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(Status.self, forKey: .status)
        self.data = try container.decode([ListingLatest].self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

public struct Status: Decodable {
    let timestamp: String?
    let error_code: Int?
    let error_message: String?
    let elapsed: Int?
    let credit_count: Int?
    let notice: String?
    let total_count: Int?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case error_code
        case error_message
        case elapsed
        case credit_count
        case notice
        case total_count
    }
    
    init(timestamp: String?, error_code: Int?, error_message: String?, elapsed: Int?, credit_count: Int?, notice: String?, total_count: Int?) {
        self.timestamp = timestamp
        self.error_code = error_code
        self.error_message = error_message
        self.elapsed = elapsed
        self.credit_count = credit_count
        self.notice = notice
        self.total_count = total_count
    }
}
