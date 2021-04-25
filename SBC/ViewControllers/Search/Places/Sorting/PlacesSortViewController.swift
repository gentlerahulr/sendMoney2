//
//  PlacesSortViewController.swift
//  SBC
//

import UIKit

protocol PlacesSortingChanged: NSObject {
    func selectionChanged(sortItems: [SortItem])
}

class SearchSortViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PlacesSortViewModel?
    weak var sortDelegate: PlacesSortingChanged?
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: "SORT_BY".localized(bundle: Bundle.main), fontSize: 16, textAlignment: .center))
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: PlacesSortCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: PlacesSortCell.reuseIdentifier)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
       closeMenu()
    }
    private func closeMenu() {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
}

extension SearchSortViewController: PlacesSortViewControllerDelegate {
    
    func sortingChanged(sortItems: [SortItem]) {
        sortDelegate?.selectionChanged(sortItems: sortItems)
    }
}

extension SearchSortViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sortItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesSortCell.reuseIdentifier, for: indexPath) as? PlacesSortCell, let sortItem = viewModel?.sortItems[indexPath.row] {
            cell.setSortItem(sortItem, showSeparatorLine: indexPath.row != 0)
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchSortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = viewModel?.sortItems[indexPath.row], item.isSelected == false else {
            closeMenu()
            return
        }
        viewModel?.selectItemAtIndex(indexPath.row)
        tableView.reloadData()
        closeMenu()
    }
}
