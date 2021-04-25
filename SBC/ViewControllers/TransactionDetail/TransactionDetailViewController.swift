import UIKit

class TransactionDetailViewController: BaseViewController {
    private var key: String?

    private var viewModel: TransactionDetailViewModelProtocol?
    @IBOutlet private var circleAvatar: CircleAvatarView? {
        willSet { newValue?.title = nil }
    }
    @IBOutlet private var labelDescription: UILabel? {
        willSet { newValue?.text = "" }
    }
    @IBOutlet private var labelDate: UILabel? {
        willSet { newValue?.text = "" }
    }
    @IBOutlet private var labelAddress: UILabel? {
        willSet { newValue?.text = "" }
    }
    @IBOutlet private var labelAmount: UILabel? {
        willSet { newValue?.text = "" }
    }
    @IBOutlet private var stackContainer: UIView? {
        willSet {
            newValue?.layer.cornerRadius = 10
            newValue?.layer.borderWidth = 2
            newValue?.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
            newValue?.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    @IBOutlet private var detailButtonCellTags: TransactionDetailButtonCell? {
        willSet {
            newValue?.title = localizedStringForKey(key: "transactiondetail.button.tags")
            newValue?.onActionClickedHandler = performEditTags
        }
    }
    @IBOutlet private var detailButtonCellNotes: TransactionDetailButtonCell? {
        willSet {
            newValue?.title = localizedStringForKey(key: "transactiondetail.button.notes")
            newValue?.onActionClickedHandler = performEditNotes
        }
    }
    private let flowStackTags = FlowStackView()

    func configureWith(transactionKey: String) {
        key = transactionKey
    }

    override func setupViewModel() {
        viewModel = TransactionDetailViewModel()
        viewModel?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let key = key {
            viewModel?.loadTransaction(key: key)
        }
    }
}

// MARK: - Private methods

extension TransactionDetailViewController {
    private func performEditTags() {
        // TODO: Implement edit tags BD-188
    }

    private func performEditNotes() {
        guard let transactionKey = key else { return }
        let vc = EditTransactionNotesViewController()
        vc.configureWith(transactionKey: transactionKey)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TransactionDetailDataPassingDelegate

extension TransactionDetailViewController: TransactionDetailDataPassingDelegate {
    func loadTransactionDidSucceed(data: TransactionDetailViewData) {
        circleAvatar?.title = data.description
        circleAvatar?.image = data.isCredit ? .credit : nil
        labelDescription?.text = data.description
        labelDate?.text = data.date
        labelAddress?.text = data.address
        labelAmount?.attributedText = .currencyFormat(
            from: data.amount,
            currency: data.currency,
            showPositiveIndicator: true,
            style: .lightBackground
        )
        if data.tags.isEmpty {
            detailButtonCellTags?.actionTitle = localizedStringForKey(key: "transactiondetail.button.addtags")
            detailButtonCellTags?.detailView = nil
        } else {
            detailButtonCellTags?.actionTitle = localizedStringForKey(key: "transactiondetail.button.edittags")
            flowStackTags.arrangedSubviews = data.tags.map {
                let view = TagView()
                view.style = .large
                view.text = $0
                return view
            }
            detailButtonCellTags?.detailView = flowStackTags
        }

        if (data.notes ?? "").isEmpty {
            detailButtonCellNotes?.actionTitle = localizedStringForKey(key: "transactiondetail.button.addnotes")
            detailButtonCellNotes?.detailView = nil
        } else {
            detailButtonCellNotes?.actionTitle = localizedStringForKey(key: "transactiondetail.button.editnotes")
            let label = UILabel()
            label.numberOfLines = 0
            label.text = data.notes
            label.textColor = .themeDarkBlueTint1
            label.font = .mediumFontWithSize(size: 16)
            detailButtonCellNotes?.detailView = label
        }
    }

    func loadTransactionDidFail(errorMessage: String) {
        CommonAlertHandler.showErrorResponseAlert(for: errorMessage)
    }

    func updateLoadingStatus(isLoading: Bool) {
        if isLoading {
            CommonUtil.sharedInstance.showLoader()
        } else {
            CommonUtil.sharedInstance.removeLoader()
        }
    }
}
