import UIKit

class TransactionListViewController: BaseViewController {
    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let searchTextField = SearchTextField()
    private var viewModel: TransactionListViewModel?
    private var sections: [TransactionListSection] = [] {
        didSet { tableView.reloadData() }
    }

    override func loadView() {
        setupSubviews()
        view = mainStackView
    }

    override func setupViewModel() {
        viewModel = TransactionListViewModel()
        viewModel?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = localizedStringForKey(key: "transactionlist.title")
        viewModel?.fetchTransactions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if parent is UINavigationController {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        viewModel?.loadCachedTransactions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if parent is UINavigationController {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
}

// MARK: - Private methods

extension TransactionListViewController {
    private func setupSubviews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 24
        tableView.estimatedSectionHeaderHeight = 32
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.layoutMargins.left = 24
        tableView.layoutMargins.right = 24
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(TransactionListCell.self)
        tableView.register(
            TransactionListSectionHeader.self,
            forHeaderFooterViewReuseIdentifier: "\(TransactionListSectionHeader.self)"
        )

        searchTextField.placeholder = localizedStringForKey(key: "transactionlist.search.placeholder")
        searchTextField.addTarget(self, action: #selector(onSearchQueryChanged), for: .editingChanged)

        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(tableView)
    }

    private func updateSearchBarVisibility(_ visible: Bool) {
        if visible {
            if searchTextField.superview == nil {
                mainStackView.insertArrangedSubview(searchTextField, at: 0)
            }
        } else {
            if searchTextField.superview != nil {
                mainStackView.removeArrangedSubview(searchTextField)
                searchTextField.removeFromSuperview()
            }
        }
    }
}

// MARK: - Event handlers

extension TransactionListViewController {
    @objc
    private func onSearchQueryChanged(sender: SearchTextField) {
        viewModel?.updateSearchQuery(tags: sender.tags, text: sender.text)
    }
}

extension TransactionListViewController: TransactionListDataPassingDelegate {
    func updateLoadingStatus(isLoading: Bool) {
        if isLoading {
            CommonUtil.sharedInstance.showLoader()
        } else {
            CommonUtil.sharedInstance.removeLoader()
        }
    }

    func updateSuggestedTags(_ tags: [String]) {
        searchTextField.suggestedTags = tags
    }

    func updateSearchQueryText(_ text: String) {
        searchTextField.text = text
    }

    func loadTransactionsDidSucceed(result: TransactionListViewState) {
        switch result {
        case .transactions(let transactions):
            updateSearchBarVisibility(true)
            tableView.backgroundView = nil
            sections = transactions
        case .placeholder(let placeholder):
            let placeholderView = ListPlaceholderView()
            placeholderView.setUp(with: ListPlaceholderView.Config(
                title: placeholder.title,
                message: placeholder.message,
                image: UIImage(named: "icon-empty-state")
            ))
            updateSearchBarVisibility(placeholder.showSearchBar)
            tableView.backgroundView = placeholderView
            sections = []
        }
    }

    func loadTransactionsDidFail(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = sections[indexPath.section].items[indexPath.row]
        let cell: TransactionListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setCellConfig(
            TransactionListCell.Config(
                transactionDescription: transaction.transactionDescription,
                amount: transaction.amount,
                currencyISO: transaction.currency,
                tags: transaction.tags,
                notes: transaction.notes
            )
        )
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
}

extension TransactionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(TransactionListSectionHeader.self)")
        if let headerView = headerView as? TransactionListSectionHeader {
            headerView.date = section.date
            headerView.amount = section.totalAmount
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = sections[indexPath.section].items[indexPath.row]
        let vc = TransactionDetailViewController()
        vc.configureWith(transactionKey: transaction.key)
        navigationController?.pushViewController(vc, animated: true)
    }
}
