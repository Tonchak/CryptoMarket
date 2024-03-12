import Foundation

extension CurrencyResponse {
    class DataSamples {
        static var successfull: Data? {
            guard let filePath = Bundle.main.path(forResource: "CurrencySuccessResponse", ofType: "json") else {
                return nil
            }
            
            return try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
        }
    }
}
