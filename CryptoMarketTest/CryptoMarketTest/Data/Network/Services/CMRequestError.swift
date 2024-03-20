import Foundation

enum CMRequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case offline
    case unathorized
    case unknown
}
