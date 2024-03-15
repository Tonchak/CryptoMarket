import XCTest
@testable import CryptoMarketTest

final class CurrenciesListViewModelTests: CryptoMarketTestCase {
    
    var storage: DataStorage!
    var sut: CurrenciesListViewModel!
    var service: DatabaseServiceMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        storage = DataStorageImplementation(isInMemoryStore: false)
        service = DatabaseServiceMock()
        sut = CurrenciesListViewModel(service: service)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        storage = nil
        service = nil
        sut = nil
    }
    
    func testFetchingData() throws {
        sut.fetchData()
        waitTask()
        
        let list = try sut.getList()
        waitTask()
        
        print(list)
    }
}
