import XCTest
@testable import CryptoMarketTest

final class CurrenciesListViewModelTests: CryptoMarketTestCase {
    
    var storage: CoreDataStorage!
    var sut: CurrenciesListViewModel!
    var service: DatabaseServiceMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        storage = CoreDataStorage(isInMemoryStore: false)
        service = DatabaseServiceMock()
        sut = CurrenciesListViewModel(service: service)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        storage = nil
        service = nil
        sut = nil
    }
    
    func testFetchingData() async throws {
        sut.fetchData()
        waitTask()
        
        let list = try await sut.getList()
        waitTask()
        
        print(list)
    }
}
