import UIKit

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearAllRecentButton: UIButton!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var recentSearchTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentSearchesHeader: UIStackView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var suggestedCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptySearchView: UIStackView!
    let viewModel = SearchViewModel()
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchResultTableHeightConstraint: NSLayoutConstraint!
    var timer: Timer?
    @IBOutlet weak var segmentedControl: MaterialSegmentedControl!
    @IBOutlet weak var sortButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadSuggestedList()
        hideTopView()
        segmentedControl.selectorColor = .black
        setSegments(segmentedControl)
        segmentedControl.updateViews()
        setupSearchBar()
        setupRecentSearches()
        setupSearchResultTableView()
        setupSortButton()
        if let trendingSearch = viewModel.trendingSearch {
            openSuggestedSearch(trendingSearch)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setSegments(_ segmentedControl: MaterialSegmentedControl) {
        segmentedControl.setSegments(segmentText: ["All", "Places", "Lists"])
        segmentedControl.setupUI()
        segmentedControl.addTarget(self, action: #selector(topSegmentDidChange(_:)), for: .valueChanged)
    }
    
    private func setupSearchBar() {
        searchBar.textField?.font = UIFont.mediumFontWithSize(size: 16)
        searchBar.textField?.textColor = .themeDarkBlue
        searchBar.setLeftImage(UIImage(named: "coreIconSearch")!, tintColor: UIColor.themeDarkBlue)
        searchBar.setRightImage(UIImage(named: "coreIconCross")!, tintColor: UIColor.themeDarkBlue)
        searchBar.changePlaceholderColor(UIColor.themeDarkBlueTint1)
        searchBar.becomeFirstResponder()
    }
    
    private func setupRecentSearches() {
        recentSearchesTableView.register(UINib(nibName: RecentSearchTableViewCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: RecentSearchTableViewCell.reuseIdentifier)
       
        clearAllRecentButton.underlineButton(text: localizedStringForKey(key: "clear_all"))
        recentSearchesTableView.delegate = self
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        setupRecentSearchesTableView()
    }
    
    private func setupSuggestedCollection() {
        suggestedCollectionView.layoutIfNeeded()
        suggestedCollectionHeightConstraint.constant = suggestedCollectionView.contentSize.height
    }
    
    private func setupRecentSearchesTableView() {
        if viewModel.recentSearches.count == 0 {
            recentSearchesTableView.isHidden = true
            recentSearchesHeader.isHidden = true
        } else {
            recentSearchesTableView.isHidden = false
            recentSearchesHeader.isHidden = false
            recentSearchesTableView.layoutIfNeeded()
            recentSearchTableHeightConstraint.constant = recentSearchesTableView.contentSize.height
        }
    }
    
    private func setupSearchResultTableView() {
        searchResultTableView.register(UINib(nibName: SearchResultCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        footer.backgroundColor = .white
        searchResultTableView.tableFooterView = footer
    }
    
    private func setupSortButton() {
        sortButton.titleLabel?.font = .regularFontWithSize(size: 12)
        updateSortButton()
    }
    
    private func updateSortButton() {
        if let sortItem = viewModel.selectedSortItem {
            sortButton.setTitle(sortItem.title, for: .normal)
        }
    }
    
    private func reloadSearchResults() {
        searchResultTableView.reloadData()
        searchResultTableView.layoutIfNeeded()
        searchResultTableHeightConstraint.constant = UIScreen.main.bounds.height - (searchResultTableView.superview?.frame.origin.y ?? 0) - 44
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAllRecentAction(_ sender: Any) {
        UserDefaults.standard.recentSearches = []
        recentSearchesTableView.reloadData()
        setupRecentSearchesTableView()
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        showSortMenu()
    }
    
    private func showSortMenu() {
            let sortVC = SearchSortViewController()
        let sortVM = SearchSortViewModel(sortItems: viewModel.sortItems)
            sortVC.viewModel = sortVM
            sortVC.sortDelegate = self
            let bottomSheetVC = BottomSheetViewController(childViewController: sortVC)
            self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
        
    }
    
    func openSuggestedSearch(_ suggestedSearch: String) {
        searchBar.text = suggestedSearch
        viewModel.addSearchToRecent(text: suggestedSearch)
        recentSearchesTableView.reloadData()
        setupRecentSearchesTableView()
        performSearch()
    }
}

// -------------------------------------
// MARK: - Table View Delegate
// -------------------------------------
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentSearchesTableView {
            return viewModel.recentSearches.count
        } else if tableView == searchResultTableView {
            return viewModel.getCurrentList(segment: segmentedControl.selectedSegmentIndex)?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recentSearchesTableView, let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.reuseIdentifier, for: indexPath) as? RecentSearchTableViewCell {
            cell.configureWithSearch(text: viewModel.recentSearches[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        } else if tableView == searchResultTableView, let cell =  tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell, let searchResult = viewModel.getCurrentList(segment: segmentedControl.selectedSegmentIndex)?[indexPath.row] {
            cell.configureWithSearchResult(searchResult)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentSearchesTableView {
            searchBar.text = viewModel.recentSearches[indexPath.row]
            performSearch()
        } else {
            if let searchResult = viewModel.getCurrentList(segment: segmentedControl.selectedSegmentIndex)?[indexPath.row] {
                switch searchResult.type {
                case "venue":
                    navigateToVenueControllerWith(venueId: searchResult.id)
                case "playlist":
                    navigateToPlaylistControllerWith(playlistId: searchResult.id)
                case "cuisine":
                    navigateToCuisine(cuisine: Cuisine(name: searchResult.name, imageUrl: nil, id: searchResult.id, isLiked: nil))
                default:
                    print("wrong type")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == searchResultTableView, let searchResultCount = viewModel.getCurrentList(segment: segmentedControl.selectedSegmentIndex)?.count, indexPath.row == searchResultCount - 1, viewModel.getNextToken(segment: segmentedControl.selectedSegmentIndex) != nil {
            viewModel.callSearchAPI(term: searchBar.text ?? "", type: segmentedControl.selectedSegmentIndex)
        }
    }
    
    private func navigateToVenueControllerWith(venueId: String) {
        let vc = VenueDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.VenueDetailsViewController)
        let vm = VenueDetailsViewModel(venueId: venueId)
        vc.viewModel = vm
        vc.viewModel?.delegate = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToPlaylistControllerWith(playlistId: String) {
        let vc = PlaylistViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.PlaylistViewController)
        let vm = PlaylistViewModel(playlistId: playlistId)
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToCuisine(cuisine: Cuisine) {
        /// TODO: merge AllPlaces storyboard into search and open it from correct storyboard
        let allPlacesViewController = PlacesViewController.instantiateFromStoryboard(storyboardName: "AllPlaces", storyboardId: StoryboardId.AllPlacesViewController)
        allPlacesViewController.viewModel = PlacesViewModel(placeMode: .cuisine(cuisine))
        navigationController?.pushViewController(allPlacesViewController, animated: true)
    }
}

// -------------------------------------
// MARK: - SearchBar Delegate
// -------------------------------------
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            performSearch(withNewText: true)
            viewModel.addSearchToRecent(text: text)
            recentSearchesTableView.reloadData()
            setupRecentSearchesTableView()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            emptySearchView.isHidden = false
            searchResultTableView.isHidden = true
            sortButton.isHidden = true
            setupSuggestedCollection()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        timer?.invalidate()
        let currentText = searchBar.text ?? ""
            if (currentText as NSString).replacingCharacters(in: range, with: text).count >= 3 {
                timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
            }
            return true
    }
    
    @objc func performSearch(withNewText: Bool = true, withNewSorting: Bool = false) {
        emptySearchView.isHidden = true
        searchResultTableView.isHidden = false
        searchBar.resignFirstResponder()
        if withNewText {
            viewModel.resetSearch()
            timer?.invalidate()
        }
        if withNewText || viewModel.getCurrentList(segment: segmentedControl.selectedSegmentIndex)?.count == 0 || withNewSorting {
            viewModel.callSearchAPI(term: searchBar.text ?? "", type: segmentedControl.selectedSegmentIndex)
        } else {
            reloadSearchResults()
        }
    }
    
    @objc func clearText() {
        emptySearchView.isHidden = false
        searchResultTableView.isHidden = true
        searchBar.text = ""
    }
}

// -------------------------------------
// MARK: - Clear Recent Search Delegate
// -------------------------------------
extension SearchViewController: ClearRecentSearchDelegate {
    func clearSearchAt(index: Int) {
        viewModel.removeSearchAt(index: index)
        recentSearchesTableView.reloadData()
        setupRecentSearchesTableView()
    }
}

// -------------------------------------
// MARK: - Collection View Delegate
// -------------------------------------
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let suggestedSearch = viewModel.suggestedList?.data?[indexPath.row] {
            openSuggestedSearch(suggestedSearch)
        }
    }
}

// -------------------------------------
// MARK: - Collection View Datasource
// -------------------------------------
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let suggested = viewModel.suggestedList?.data {
            return suggested.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let suggested = viewModel.suggestedList?.data, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as? TagCollectionViewCell {
            cell.config(info: suggested[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}

// -------------------------------------
// MARK: - Collection View Flow Layout
// -------------------------------------
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let suggested = viewModel.suggestedList?.data {
            let size = suggested[indexPath.row].getTextSize(UIFont.regularFontWithSize(size: 13), maxHeight: 20)
            return CGSize(width: size.width + 16, height: 20)
        }
        return CGSize.zero
    }
}

// -------------------------------------
// MARK: - Search Delegate
// -------------------------------------
extension SearchViewController: SearchDelegate {
    func didLoadSuggestedSearches() {
        suggestedCollectionView.reloadData()
        setupSuggestedCollection()
    }
    func didReceiveData() {
        reloadSearchResults()
    }
    func failureWithError() {
        suggestedCollectionView.reloadData()
        setupSuggestedCollection()
    }
}

// -------------------------------------
// MARK: - Segment Delegate
// -------------------------------------
extension SearchViewController {
    @objc func topSegmentDidChange(_ sender: MaterialSegmentedControl) {
        if searchBar.text == nil || searchBar.text == "" {
            switch sender.selectedSegmentIndex {
            case 0:
                emptySearchView.isHidden = false
            default:
                emptySearchView.isHidden = true
            }
        } else {
            performSearch(withNewText: false)
            sortButton.isHidden = sender.selectedSegmentIndex == 0
        }
    }
}

// -------------------------------------
// MARK: - Sorting Delegate
// -------------------------------------
extension SearchViewController: SearchSortingChanged {
    func selectionChanged(sortItems: [SortItem]) {
        viewModel.sortItems = sortItems
        performSearch(withNewText: false, withNewSorting: true)
        updateSortButton()
    }
}
