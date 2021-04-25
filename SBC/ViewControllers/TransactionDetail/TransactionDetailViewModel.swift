import Foundation

struct TransactionDetailViewData {
    let key: String
    let description: String
    let date: String
    let address: String?
    let amount: Double
    let currency: String
    let isCredit: Bool
    let tags: [String]
    let notes: String?
}

protocol TransactionDetailViewModelProtocol {
    var delegate: TransactionDetailDataPassingDelegate? { get set }
    func loadTransaction(key: String)
}

protocol TransactionDetailDataPassingDelegate: class {
    func loadTransactionDidSucceed(data: TransactionDetailViewData)
    func loadTransactionDidFail(errorMessage: String)
    func updateLoadingStatus(isLoading: Bool)
}

class TransactionDetailViewModel {
    private weak var _delegate: TransactionDetailDataPassingDelegate?
    @Injected private var moneyThorManager: MoneyThorManager
}

extension TransactionDetailViewModel: TransactionDetailViewModelProtocol {
    func loadTransaction(key: String) {
        if let transaction = moneyThorManager.loadCachedTransactions(of: [key]).first {
            delegate?.loadTransactionDidSucceed(data: transaction.toViewData())
        } else {
            delegate?.updateLoadingStatus(isLoading: true)
            moneyThorManager.performGetTransaction(
                request: MTTransactionDetailRequest(key: key)
            ) { [weak self] result in
                self?.delegate?.updateLoadingStatus(isLoading: false)
                do {
                    let response = try result.get()
                    self?.delegate?.loadTransactionDidSucceed(data: response.payload.toViewData())
                } catch {
                    self?.delegate?.loadTransactionDidFail(errorMessage: error.localizedDescription)
                }
            }
        }
    }

    var delegate: TransactionDetailDataPassingDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }
}

extension MTTransaction {
    private var signedAmount: Double {
        switch movement {
        case .credit:
            return amount
        case .debit:
            return -amount
        }
    }

    fileprivate func toViewData() -> TransactionDetailViewData {
        TransactionDetailViewData(
            key: key,
            description: description ?? "",
            date: String.fromDate(date, dateFormat: .ddMMMMyyyyE, doesRelativeFormatting: false),
            address: nil,
            amount: signedAmount,
            currency: currency,
            isCredit: movement == .credit,
            tags: tags,
            notes: notes
        )
    }
}
