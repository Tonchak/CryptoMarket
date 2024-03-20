import Foundation
import BackedCodable

struct CurrencyResponseDTO: BackedDecodable {
    
    init(_: DeferredDecoder) {}
    
    @Backed(Path("data", "results"))
    var currencies: [CurrencyDTO]
}
