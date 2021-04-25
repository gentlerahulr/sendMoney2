import XCTest
@testable import ONZ

class MoneyThorModelsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

// MARK: Test - MTPayloadResponse<[MTTransaction]>

extension MoneyThorModelsTests {
    func test_parseTransactionsResponse_shouldSucceed() {
        // Given
        guard let jsonData = ResourceHelper.data(forResource: "moneythor_searchtransactions", ext: "json") else {
            fatalError("Fail to load mock data")
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted({
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }())

        // When and Then
        XCTAssertNoThrow(try decoder.decode(MTPayloadResponse<[MTTransaction]>.self, from: jsonData))
    }
}

// MARK: Test - MTPayloadResponse<[MTTransactionCategory]>

extension MoneyThorModelsTests {
    func test_parseTransactionCategoriesResponse_shouldSucceed() {
        // Given
        guard let jsonData = ResourceHelper.data(forResource: "moneythor_getcategories", ext: "json") else {
            fatalError("Fail to load mock data")
        }
        let decoder = JSONDecoder()

        // When and Then
        XCTAssertNoThrow(try decoder.decode(MTPayloadResponse<[MTTransactionCategory]>.self, from: jsonData))
    }
}
