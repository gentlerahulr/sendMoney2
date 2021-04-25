import Foundation

enum TransactionListViewState {
    case transactions([TransactionListSection])
    case placeholder(TransactionListPlaceHolder)
}

struct TransactionListPlaceHolder {
    let title: String
    let message: String
    let showSearchBar: Bool
}

struct TransactionListSection {
    struct Item {
        let key: String
        let transactionDescription: String?
        let amount: Double
        let currency: String
        let tags: [String]
        let notes: String?
    }

    let date: Date
    var items: [Item]
}

extension TransactionListSection {
    var totalAmount: Double {
        items.reduce(0.0) { $0 + $1.amount }
    }
}
