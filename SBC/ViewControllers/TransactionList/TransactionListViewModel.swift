import Foundation

protocol TransactionListDataPassingDelegate: class {
    func updateLoadingStatus(isLoading: Bool)
    func updateSuggestedTags(_ tags: [String])
    func updateSearchQueryText(_ text: String)
    func loadTransactionsDidSucceed(result: TransactionListViewState)
    func loadTransactionsDidFail(message: String)
}

protocol TransactionListViewModelProtocol {
    var delegate: TransactionListDataPassingDelegate? { get set }
    func fetchTransactions()
    func loadCachedTransactions()
    func updateSearchQuery(tags: [String], text: String?)
}

class TransactionListViewModel: BaseViewModel {
    @Injected private var moneyThorManager: MoneyThorManager
    private weak var _delegate: TransactionListDataPassingDelegate?
    private var searchQuery: String = "" {
        willSet {
            // Show suggested tags
            if let lastComponent = newValue.split(separator: " ").last?.lowercased(), !lastComponent.isEmpty {
                let suggestedTags = allTags.filter {
                    $0.lowercased().hasPrefix(lastComponent) && !selectedTags.contains($0)
                }
                delegate?.updateSuggestedTags(suggestedTags)
            } else {
                delegate?.updateSuggestedTags([])
            }
        }
    }
    private var selectedTags: [String] = [] {
        didSet {
            // Delete last text component if adding new tag
            if oldValue.count < selectedTags.count && !searchQuery.isEmpty {
                var components = searchQuery.split(separator: " ").map { String($0) }
                components.removeLast()
                searchQuery = components.joined(separator: " ") + " "
                delegate?.updateSearchQueryText(searchQuery)
            }
        }
    }
    private var allTags: [String] = []
    private var state: TransactionListViewState? {
        willSet {
            guard let newValue = newValue else { return }
            delegate?.loadTransactionsDidSucceed(result: newValue)
        }
    }
    private var searchTimer: Timer?
}

extension TransactionListViewModel: TransactionListViewModelProtocol {
    var delegate: TransactionListDataPassingDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }

    func fetchTransactions() {
        delegate?.updateLoadingStatus(isLoading: true)
        performFetchCategories { [weak self] fetchCategorySuccess in
            if fetchCategorySuccess {
                self?.performFetchTransactions(searchQuery: nil) { [weak self] in
                    self?.delegate?.updateLoadingStatus(isLoading: false)
                }
            } else {
                self?.delegate?.updateLoadingStatus(isLoading: false)
            }
        }
    }

    func loadCachedTransactions() {
        guard case .some(TransactionListViewState.transactions(let sections)) = state else {
            return
        }
        let transactionKeys = sections.flatMap { $0.items }.map { $0.key }
        let cachedTransactions = moneyThorManager.loadCachedTransactions(of: transactionKeys)
        if transactionKeys.count == cachedTransactions.count {
            state = viewState(
                with: cachedTransactions.toSections(),
                searchQuery: searchQuery,
                selectedTags: selectedTags
            )
        }
    }

    func updateSearchQuery(tags: [String], text: String?) {
        searchQuery = text ?? ""
        selectedTags = tags
        enqueueSearchTask()
    }
}

extension TransactionListViewModel {
    private func performFetchCategories(completion: @escaping (Bool) -> Void) {
        moneyThorManager.performGetTransactionCategories { [weak self] result in
            do {
                let categories = try result.map({ $0.payload }).get()
                self?.allTags = categories.map { $0.category }
                completion(true)
            } catch {
                self?.delegate?.loadTransactionsDidFail(message: error.localizedDescription)
                completion(false)
            }
        }
    }

    private func performFetchTransactions(searchQuery: String?, completion: @escaping () -> Void) {
        moneyThorManager.performGetTransactionList(
            request: MTTransactionListRequest(query: searchQuery)
        ) { [weak self] result in
            do {
                let transactions = try result.map({ $0.payload.toSections() }).get()
                self?.state = viewState(
                    with: transactions,
                    searchQuery: searchQuery,
                    selectedTags: self?.selectedTags ?? []
                )
                completion()
            } catch {
                self?.delegate?.loadTransactionsDidFail(message: error.localizedDescription)
                completion()
            }
        }
    }

    private func enqueueSearchTask() {
        let tagsComponents = selectedTags.map { "#\($0)" }
        let textComponents = searchQuery.split(separator: " ")
            .filter { !$0.isEmpty }
            .map { String($0) }
        let query = (tagsComponents + textComponents).joined(separator: " AND ")
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.performFetchTransactions(searchQuery: query) { }
        }
    }
}

private func viewState(
    with sections: [TransactionListSection],
    searchQuery: String?,
    selectedTags: [String]
) -> TransactionListViewState {
    switch (sections.isEmpty, (searchQuery ?? "").isEmpty && selectedTags.isEmpty) {
    case (true, true):
        return .placeholder(TransactionListPlaceHolder(
            title: localizedStringForKey(key: "transactionlist.placeholder.title.notransactions"),
            message: localizedStringForKey(key: "transactionlist.placeholder.message.notransactions"),
            showSearchBar: false
        ))
    case (true, false):
        return .placeholder(TransactionListPlaceHolder(
            title: localizedStringForKey(key: "transactionlist.placeholder.title.nosearchedtransactions"),
            message: localizedStringForKey(key: "transactionlist.placeholder.message.nosearchedtransactions"),
            showSearchBar: true
        ))
    case (false, _):
        return .transactions(sections)
    }
}

extension Array where Element == MTTransaction {
    fileprivate func toSections() -> [TransactionListSection] {
        reduce(into: [TransactionListSection]()) { result, transaction in
            let newItem = transaction.toTransactionItem()
            if let index = result.firstIndex(where: { $0.date == transaction.date }) {
                result[index].items.append(newItem)
            } else {
                let section = TransactionListSection(
                    date: transaction.date,
                    items: [newItem]
                )
                result.append(section)
            }
        }
    }
}

extension MTTransaction {
    fileprivate func toTransactionItem() -> TransactionListSection.Item {
        TransactionListSection.Item(
            key: key,
            transactionDescription: description,
            amount: movement == .credit ? amount : -1 * amount,
            currency: currency,
            tags: tags,
            notes: notes
        )
    }
}
