import Foundation

protocol HTTPClient {
    func executeRequest<T: Decodable>(endpoint: CMRouter, responseModel: T.Type) async throws -> T
}

extension HTTPClient {
    func executeRequest<T: Decodable>(
        endpoint: CMRouter,
        responseModel: T.Type
    ) async throws -> T {
        
        let request = URLComponents(string: endpoint.url)!
        
        guard let url = request.url else { throw CMRequestError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = endpoint.method
        
        if let headers = endpoint.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw CMRequestError.decode
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    throw CMRequestError.decode
                }
                return decodedResponse
            case 401:
                throw CMRequestError.unathorized
            default:
                throw CMRequestError.unknown
            }
            
        } catch URLError.Code.notConnectedToInternet {
            throw CMRequestError.offline
        }
    }
}
