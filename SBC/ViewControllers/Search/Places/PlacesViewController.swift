//
//  PlacesViewController.swift
//  SBC
//

import UIKit

class PlacesViewController: BaseViewController {
    
    var viewModel: PlacesViewModel?
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var skeletonView: SkeletonViewAllPlaces?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        viewModel?.delegate = self
        setupTableView()
        setupSortButton()
        addSkeletonView()
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        showSortMenu()
    }
    
    private func setupSortButton() {
        sortButton.titleLabel?.font = .regularFontWithSize(size: 12)
        updateSortButton()
    }
    
    private func updateSortButton() {
        if let sortItem = viewModel?.selectedSortItem {
            sortButton.setTitle(sortItem.title, for: .normal)
        }
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
        showScreenTitleWithLeftBarButton(screenTitle: viewModel?.title, screenTitleColor: colorConfig.navigation_header_text_color)
        IBViewTop.setLeftButtonColor(color: .themeDarkBlue)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: SearchResultCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
    }
    
    private func showSortMenu() {
        if let sortItems = viewModel?.sortItems {
            let sortVC = SearchSortViewController()
            let sortVM = SearchSortViewModel(sortItems: sortItems)
            sortVC.viewModel = sortVM
            sortVC.sortDelegate = self
            let bottomSheetVC = BottomSheetViewController(childViewController: sortVC)
            self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
        }
    }

}

extension PlacesViewController: PlacesDataDelegate {
    
    func failureWithError(message: String) {
        tableView.reloadData()
        hideSkeletonView()
    }
    
    func didReceiveData() {
        tableView.reloadData()
        hideSkeletonView()
    }
}

extension PlacesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.venuesSearchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell, let searchResult = viewModel?.venuesSearchResults?[indexPath.row] {
            cell.configureWithSearchResult(searchResult)
            return cell
        }
        return UITableViewCell()
    }
}

extension PlacesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonAlertHandler.showErrorResponseAlert(for: "Will be part of story BDH-247")
    }
}

// -------------------------------------
// MARK: - SkeletonControl
// -------------------------------------
extension PlacesViewController {
    
    func addSkeletonView() {
        if let skeletonView = UIView.fromNib(SkeletonViewAllPlaces.nib) as? SkeletonViewAllPlaces {
            skeletonView.frame = UIScreen.main.bounds
            skeletonView.layoutSubviews()
            view.addSubview(skeletonView)
            skeletonView.showSkeleton()
            self.skeletonView = skeletonView
        }
    }
    
    func hideSkeletonView() {
        skeletonView?.hideSkeleton()
        skeletonView?.removeFromSuperview()
    }
}

extension PlacesViewController: SearchSortingChanged {
    
    func selectionChanged(sortItems: [SortItem]) {
        addSkeletonView()
        viewModel?.sortItems = sortItems
        updateSortButton()
    }
    
}
