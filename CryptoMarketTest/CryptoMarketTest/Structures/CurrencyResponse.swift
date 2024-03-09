import Foundation

public struct CurrencyResponse: Decodable {
    let status: Status?
    var data: Array<ListingLatest>?
}

public struct Status: Decodable {
    let timestamp: String?
    let error_code: Int?
    let error_message: String?
    let elapsed: Int?
    let credit_count: Int?
    let notice: String?
    let total_count: Int?
}
