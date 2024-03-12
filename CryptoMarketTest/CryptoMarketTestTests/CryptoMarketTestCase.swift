import XCTest
@testable import CryptoMarketTest

class CryptoMarketTestCase: XCTestCase {
    func waitTask(seconds: TimeInterval = 1) {
        let expectation = expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: seconds)
    }
}
