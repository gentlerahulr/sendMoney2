@testable import ONZ
import XCTest
import Cuckoo

class TransactionListViewModelTests: XCTestCase {
    var sut: TransactionListViewModel?

    let moneyThorManager = MockMoneyThorManager(dataStore: MockDataProviderProtocol())
    let delegate = MockTransactionListDataPassingDelegate()

    override func setUpWithError() throws {
        ServiceLocator.shared.register(moneyThorManager as MoneyThorManager)
        sut = TransactionListViewModel()
        sut?.delegate = delegate

        stub(delegate) { stub in
            stub.updateLoadingStatus(isLoading: any()).thenDoNothing()
            stub.updateSearchQueryText(any()).thenDoNothing()
            stub.updateSuggestedTags(any()).thenDoNothing()
            stub.loadTransactionsDidFail(message: any()).thenDoNothing()
            stub.loadTransactionsDidSucceed(result: any()).thenDoNothing()
        }
    }

    override func tearDownWithError() throws {
        clearInvocations(delegate)
        clearInvocations(moneyThorManager)
    }
}

// MARK: - test loadTransactions()

extension TransactionListViewModelTests {

    func test_fetchTransactions_shouldStartAndThenStopLoading() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).updateLoadingStatus(isLoading: true)
        verify(delegate).updateLoadingStatus(isLoading: false)
    }

    func test_fetchTransactions_withSuccessGetCategoriesResponse_shouldGetTransactions() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()

        // When
        sut?.fetchTransactions()

        // Then
        verify(moneyThorManager).performGetTransactionList(request: any(), completion: any())
    }

    func test_fetchTransactions_withFailureGetCategoriesResponse_shouldNotGetTransactions() {
        // Given
        arrangeGetTransactionCategoriesFailure()
        arrangeGetTransactionListSuccess()

        // When
        sut?.fetchTransactions()

        // Then
        verify(moneyThorManager, never()).performGetTransactionList(request: any(), completion: any())
    }

    func test_fetchTransactions_withEmptyResponse_shouldShowPlaceholder() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).loadTransactionsDidSucceed(result: ParameterMatcher {
            if case .placeholder(let placeholder) = $0 {
                return placeholder.title == "transactionlist.placeholder.title.notransactions".localized &&
                    placeholder.message == "transactionlist.placeholder.message.notransactions".localized
            }
            return false
        })
    }

    func test_fetchTransactions_withEmptyResponse_shouldHideSearchBar() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).loadTransactionsDidSucceed(result: ParameterMatcher {
            if case .placeholder(let placeholder) = $0 {
                return placeholder.showSearchBar == false
            }
            return false
        })
    }

    func test_fetchTransactions_withEmptyResponseWhenSearching_shouldShowPlaceholder() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()
        sut?.updateSearchQuery(tags: ["foo"], text: nil)

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).loadTransactionsDidSucceed(result: ParameterMatcher {
            if case .placeholder(let placeholder) = $0 {
                return placeholder.title == "transactionlist.placeholder.title.nosearchedtransactions".localized &&
                    placeholder.message == "transactionlist.placeholder.message.nosearchedtransactions".localized
            }
            return false
        })
    }

    func test_fetchTransactions_withEmptyResponseWhenSearching_shouldHideSearchBar() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListSuccess()
        sut?.updateSearchQuery(tags: ["foo"], text: nil)

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).loadTransactionsDidSucceed(result: ParameterMatcher {
            if case .placeholder(let placeholder) = $0 {
                return placeholder.showSearchBar == true
            }
            return false
        })
    }

    func test_fetchTransactions_withErrorResposne_shouldShowError() {
        // Given
        arrangeGetTransactionCategoriesSuccess()
        arrangeGetTransactionListFailure()

        // When
        sut?.fetchTransactions()

        // Then
        verify(delegate).loadTransactionsDidFail(message: any())
    }
}

// MARK: - test updateSearchQuery

extension TransactionListViewModelTests {
    func test_updateSearchQuery_shouldShowSuggestedCategories() {
        // Given
        arrangeGetTransactionCategoriesSuccess(categories: ["foo", "bar", "baz"])
        arrangeGetTransactionListSuccess()
        sut?.fetchTransactions()

        // When
        sut?.updateSearchQuery(tags: [], text: "b")

        // Then
        verify(delegate).updateSuggestedTags(["bar", "baz"])
    }

    func test_updateSearchQuery_withSelectedTags_shouldShowSuggestedCategoriesExceptSelected() {
        // Given
        arrangeGetTransactionCategoriesSuccess(categories: ["foo", "bar", "baz"])
        arrangeGetTransactionListSuccess()
        sut?.fetchTransactions()

        // When
        sut?.updateSearchQuery(tags: ["bar"], text: "b")

        // Then
        verify(delegate).updateSuggestedTags(["bar", "baz"])
    }

    func test_updateSearchQuery_withExtraTags_shouldDeleteTheLastComponentOfTextInput() {
        // Given
        sut?.updateSearchQuery(tags: ["foo"], text: "")

        // When
        sut?.updateSearchQuery(tags: ["foo", "bar"], text: "test ba")

        // Then
        verify(delegate, atLeastOnce()).updateSearchQueryText("test ")
    }

    func test_updateSearchQuery_shouldFetchTransactionListAfter1SecondWithCorrectQuery() {
        // Given
        arrangeGetTransactionListSuccess()
        let tags = ["foo", "bar"]
        let text = "text"
        let query = (tags.map { "#\($0)" } + ["text"]).joined(separator: " AND ")

        // When
        sut?.updateSearchQuery(tags: tags, text: text)
        sut?.updateSearchQuery(tags: tags, text: text)

        // Then
        waitForInterval(1)
        verify(moneyThorManager).performGetTransactionList(request: ParameterMatcher {
            $0.query == query
        }, completion: any())
    }

    func test_updateSearchQuery_withMultipleChanges_shouldFetchTransactionListAfter1SecondOnlyOnce() {
        // Given
        arrangeGetTransactionListSuccess()
        let secondQuery = "bar"

        // When
        sut?.updateSearchQuery(tags: [], text: "foo")
        sut?.updateSearchQuery(tags: [], text: secondQuery)

        // Then
        waitForInterval(1)
        verify(moneyThorManager, times(1)).performGetTransactionList(request: ParameterMatcher {
            $0.query == secondQuery
        }, completion: any())
    }
}

// MARK: Private helpers

extension TransactionListViewModelTests {
    private func waitForInterval(_ interval: TimeInterval) {
        let waiter = expectation(description: String(format: "wait for %.0f second(s)", interval))
        DispatchQueue.main.asyncAfter(deadline: .now() + interval + 0.5) {
            waiter.fulfill()
        }
        waitForExpectations(timeout: interval + 1, handler: nil)
    }
}

// MARK: - Arrange methods

extension TransactionListViewModelTests {
    private func arrangeGetTransactionListSuccess(transactions: [MTTransaction] = []) {
        stub(moneyThorManager) { stub in
            stub.performGetTransactionList(request: any(), completion: any()).then { _, completion in
                completion(.success(MTPayloadResponse(payload: transactions)))
            }
        }
    }

    private func arrangeGetTransactionListFailure() {
        stub(moneyThorManager) { stub in
            stub.performGetTransactionList(request: any(), completion: any()).then { _, completion in
                completion(.failure(APIError.response(URLError(.badServerResponse))))
            }
        }
    }

    private func arrangeGetTransactionCategoriesSuccess(categories: [String] = []) {
        stub(moneyThorManager) { stub in
            let payload = categories.map {
                MTTransactionCategory(category: $0, type: .custom, parent: nil, locales: nil)
            }
            stub.performGetTransactionCategories(completion: any()).then { completion in
                completion(.success(MTPayloadResponse(payload: payload)))
            }
        }
    }

    private func arrangeGetTransactionCategoriesFailure() {
        stub(moneyThorManager) { stub in
            stub.performGetTransactionCategories(completion: any()).then { completion in
                completion(.failure(APIError.response(URLError(.badServerResponse))))
            }
        }
    }
}
