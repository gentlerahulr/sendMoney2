import Foundation

struct EditTransactionNotesInputState {
    let isCTAEnabled: Bool
    let errorMessage: String?
}

protocol EditTransactionNotesDataPassingDelegate: class {
    func loadTransactionNotesDidComplete(notes: String?, maximumCharactorCount: Int)
    func updateInputState(_ state: EditTransactionNotesInputState)
    func updateNoteDidSucceed()
    func updateNoteDidFail(errorMessage: String)
    func updateLoadingStatus(isLoading: Bool)
}

protocol EditTransactionNotesViewModelProtocol {
    var delegate: EditTransactionNotesDataPassingDelegate? { get set }
    func loadTransactionNotes(of transactionKey: String)
    func editNotes(_ notes: String)
    func saveNotes(of transactionKey: String, notes: String)
}

class EditTransactionNotesViewModel: BaseViewModel {
    @Injected private var moneyThorManager: MoneyThorManager
    private weak var _delegate: EditTransactionNotesDataPassingDelegate?
}

// MARK: - EditTransactionNotesViewModelProtocol

extension EditTransactionNotesViewModel: EditTransactionNotesViewModelProtocol {
    var delegate: EditTransactionNotesDataPassingDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }

    func loadTransactionNotes(of transactionKey: String) {
        if let transaction = moneyThorManager.loadCachedTransactions(of: [transactionKey]).first {
            handleTransactionNotes(transaction.notes ?? "")
        } else {
            delegate?.updateLoadingStatus(isLoading: true)
            moneyThorManager.performGetTransaction(
                request: MTTransactionDetailRequest(key: transactionKey)
            ) { [weak self] result in
                self?.delegate?.updateLoadingStatus(isLoading: true)
                self?.handleTransactionNotes((try? result.get())?.payload.notes ?? "")
            }
        }
    }

    func saveNotes(of transactionKey: String, notes: String) {
        delegate?.updateLoadingStatus(isLoading: true)
        moneyThorManager.performUpdateTransactionNote(
            transactionKey: transactionKey,
            notes: notes.trim()
        ) { [weak self] result in
            self?.delegate?.updateLoadingStatus(isLoading: false)
            switch result {
            case .success:
                self?.delegate?.updateNoteDidSucceed()
            case .failure(let error):
                self?.delegate?.updateNoteDidFail(errorMessage: error.localizedDescription)
            }
        }
    }

    func editNotes(_ notes: String) {
        delegate?.updateInputState(inputState(with: notes))
    }
}

// MARK: - Private methods

extension EditTransactionNotesViewModel {
    private func handleTransactionNotes(_ notes: String) {
        delegate?.updateInputState(inputState(with: notes))
        delegate?.loadTransactionNotesDidComplete(
            notes: notes,
            maximumCharactorCount: Config.TRANSACTION_NOTES_MAX_CHARACTER_COUNT
        )
    }

    private func inputState(with notes: String) -> EditTransactionNotesInputState {
        var errorMessage: String?
        if notes.count > Config.TRANSACTION_NOTES_MAX_CHARACTER_COUNT {
            errorMessage = localizedStringForKey(key: "transactiondetail.edit.error.exceedlimit")
        }
        return EditTransactionNotesInputState(
            isCTAEnabled: !(notes.isEmpty || notes.count > Config.TRANSACTION_NOTES_MAX_CHARACTER_COUNT),
            errorMessage: errorMessage
        )
    }
}
