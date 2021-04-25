import Foundation

typealias GetTransactionListCompletionHandler = (Result<MTPayloadResponse<[MTTransaction]>, APIError>) -> Void
typealias GetTransactionCompletionHandler = (Result<MTPayloadResponse<MTTransaction>, APIError>) -> Void
typealias GetTransactionCategoriesCompletionHandler = (
    Result<MTPayloadResponse<[MTTransactionCategory]>, APIError>
) -> Void
typealias UpdateTransactionCompletionHandler = (Result<MTAcknowledgementResponse, APIError>) -> Void

class MoneyThorManager: BaseManager {
    private var transactionsCache: [String: MTTransaction] = [:]

    func performGetTransactionList(
        request: MTTransactionListRequest,
        completion: @escaping GetTransactionListCompletionHandler
    ) {
        dataStore.moneyThorService.performGetTransactionList(request: request) { [weak self] result in
            if let response = try? result.get() {
                self?.cacheTransactions(response.payload)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func performGetTransaction(
        request: MTTransactionDetailRequest,
        completion: @escaping GetTransactionCompletionHandler
    ) {
        dataStore.moneyThorService.performGetTransaction(request: request) { [weak self] result in
            if let response = try? result.get() {
                self?.cacheTransactions([response.payload])
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func performGetTransactionCategories(completion: @escaping GetTransactionCategoriesCompletionHandler) {
        dataStore.moneyThorService.performGetTransactionCategories { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func performUpdateTransactionNote(
        transactionKey: String,
        notes: String,
        completion: @escaping UpdateTransactionCompletionHandler
    ) {
        dataStore.moneyThorService.performSyncTransactionCustomFields(
            request: MTSyncTransactionCustomFieldRequest(
                key: transactionKey,
                customFields: [
                    CustomField(name: CustomFieldKeys.customNotes, value: .string(notes))
                ]
            )
        ) { [weak self] updateResult in
            self?.dataStore.moneyThorService.performGetTransaction(
                request: MTTransactionDetailRequest(key: transactionKey)
            ) { [weak self] result in
                if let response = try? result.get() {
                    self?.cacheTransactions([response.payload])
                }
                DispatchQueue.main.async {
                    completion(updateResult)
                }
            }
        }
    }

    func loadCachedTransactions(of keys: [String]) -> [MTTransaction] {
        keys.compactMap { transactionsCache[$0] }
    }
}

extension MoneyThorManager {
    private func findCachedTransaction(by key: String) -> MTTransaction? {
        transactionsCache[key]
    }

    private func cacheTransactions(_ transactions: [MTTransaction]) {
        transactions.forEach {
            transactionsCache[$0.key] = $0
        }
    }
}
