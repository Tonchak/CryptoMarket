import XCTest


class CryptoMarketTestTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testSingletonConceptual() {
        DatabaseHandler.checkAPIManagerInstance()
    }
    
}
