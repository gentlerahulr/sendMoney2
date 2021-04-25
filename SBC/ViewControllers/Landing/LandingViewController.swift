//
//  LandingViewController.swift
//  SBC
//

import UIKit

class LandingViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var playlistCollectionView: UICollectionView?
    weak var venueCollectionView: UICollectionView?
    private let viewModel = LandingViewModel()
    private var storedOffsets = [Int: [Int: CGFloat]]()
    private var skeletonView: SkeletonViewLanding?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTableView()
        setupNavigation()
        addSkeletonView()
        viewModel.loadSearchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.callRecommendationsAPI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: PlaylistTileCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: PlaylistTileCell.reuseIdentifier)
        tableView.register(UINib(nibName: BigVenueCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: BigVenueCell.reuseIdentifier)
        tableView.register(UINib(nibName: CollectionViewContainerCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: CollectionViewContainerCell.reuseIdentifier)
        tableView.register(HeaderTitleView.self, forHeaderFooterViewReuseIdentifier: HeaderTitleView.reuseIdentifier)
        
        if let header = UIView.fromNib(LandingHeaderCell.nib) as? LandingHeaderCell {
            tableView.tableHeaderView = header
            header.likeButtonAction = navigateToYourLikes
        }
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        footer.backgroundColor = .white
        tableView.tableFooterView = footer
    }
    
    @objc
    private func navigateToYourLikes() {
        let vc = YourLikesViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Discovery, storyboardId: StoryboardId.YourLikesViewController)
        let vm = YourLikesViewModel()
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
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
        vc.delegate = self
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openVenueMenu(venue: Venue) {
        let addToPlaylistVC = AddToListViewController()
        addToPlaylistVC.delegate = self
        let addToListVM = AddToListViewModel(venue: venue)
        addToListVM.delegate = addToPlaylistVC
        addToPlaylistVC.viewModel = addToListVM
        let bottomSheetVC = BottomSheetViewController(childViewController: addToPlaylistVC)
        self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    private func likeVenue(_ indexPath: IndexPath?) {
        if let indexPath = indexPath, var venue = viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] {
            venue.isLiked = !venue.isLiked
            let toAdd = venue.isLiked ? 1 : -1
            venue.likeCount += toAdd
            viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] = venue
            if indexPath.row == 0 {
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                let tablePath = IndexPath(row: 1, section: indexPath.section)
                tableView.reloadRows(at: [tablePath], with: .none)
            }
        }
        viewModel.likeVenue(indexPath: indexPath)
    }
    
    private func likePlaylist(_ indexPath: IndexPath?) {
        if let indexPath = indexPath, var playlist = viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] {
            playlist.isLiked = !playlist.isLiked
            let toAdd = playlist.isLiked ? 1 : -1
            playlist.likeCount += toAdd
            viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] = playlist
            if indexPath.row == 0 {
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                let tablePath = IndexPath(row: 1, section: indexPath.section)
                tableView.reloadRows(at: [tablePath], with: .none)
            }
        }
        viewModel.likePlaylist(indexPath: indexPath)
    }
}

// -------------------------------------
// MARK: - SkeletonControl
// -------------------------------------
extension LandingViewController {
    
    func addSkeletonView() {
        if let skeletonView = UIView.fromNib(SkeletonViewLanding.nib) as? SkeletonViewLanding {
            view.addSubview(skeletonView)
            self.skeletonView = skeletonView
        }
    }
    
    func hideSkeletonView() {
        skeletonView?.removeFromSuperview()
    }
}

// -------------------------------------
// MARK: - LandingDataDelegate
// -------------------------------------
extension LandingViewController: LandingDataDelegate {
    
    func didReceiveData(venue: Venue, forMenu: Bool) {
        if forMenu {
            openVenueMenu(venue: venue)
        } 
    }
    
    func didReceiveData(recommendationsResponse: RecommendationsResponse) {
        hideSkeletonView()
        tableView.reloadData()
    }
    
    func didReceiveData(recommendationsResponse: RecommendationsResponse, indexPath: IndexPath, type: RecommendationsType, isForTableView: Bool) {
        
        if isForTableView {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            switch type {
            case .playlist:
                playlistCollectionView?.reloadItems(at: [indexPath])
            default:
                venueCollectionView?.reloadItems(at: [indexPath])
            }
        }
    }
    
    func failureWithError(message: String) {
        hideSkeletonView()
        tableView.reloadData()
    }
    
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?) {
        if error != nil {
            if let indexPath = indexPath {
                if var playlist = viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] {
                    playlist.isLiked = !playlist.isLiked
                    let toAdd = playlist.isLiked ? 1 : -1
                    playlist.likeCount += toAdd
                    tableView.reloadData()
                }
            }
        }
    }
    
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?) {
        if error != nil {
            if let indexPath = indexPath {
                if var venue = viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row] {
                    venue.isLiked = !venue.isLiked
                    let toAdd = venue.isLiked ? 1 : -1
                    venue.likeCount += toAdd
                    tableView.reloadData()
                }
            }
        }
    }
}

// -------------------------------------
// MARK: - UITableViewDataSource
// -------------------------------------
extension LandingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.recommendations?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recommendations = viewModel.recommendations?.data[section].recommendations
        let recommendationsCount = recommendations?.count ?? 0
        return recommendationsCount > 1 ? 2 : recommendationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recommendationsList = viewModel.recommendations?.data[indexPath.section] else {
            return UITableViewCell()
        }
        
        let recommendations = recommendationsList.recommendations
        var isBigTile = false
        if recommendationsList.type == RecommendationsType.playlist.rawValue {
            isBigTile = recommendations.count == 1 || indexPath.row == 0
            return createPlaylistCell(tableView, cellForRowAt: indexPath, recommendation: recommendations[indexPath.row], asBigTile: isBigTile)
        }
        
        if recommendationsList.type == RecommendationsType.venue.rawValue {
            isBigTile = recommendations.count == 1 || indexPath.row == 0
            return createVenuesCell(tableView, cellForRowAt: indexPath, recommendation: recommendations[indexPath.row], asBigTile: isBigTile)
        }
        return UITableViewCell()
    }
    
    private func createPlaylistCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, recommendation: Recommendation, asBigTile: Bool) -> UITableViewCell {
        
        if asBigTile {
            return createPlaylistTileCell(tableView, cellForRowAt: indexPath, recommendation: recommendation)
        } else {
            let cell = createCollectionViewContainerCell(tableView, cellForRowAt: indexPath)
            playlistCollectionView = cell.collectionView
            return cell
        }
    }
    
    private func createVenuesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, recommendation: Recommendation, asBigTile: Bool) -> UITableViewCell {
        
        if asBigTile {
            return createBigVenueTableViewCell(tableView, cellForRowAt: indexPath, recommendation: recommendation)
        } else {
            let cell = createCollectionViewContainerCell(tableView, cellForRowAt: indexPath)
            venueCollectionView = cell.collectionView
            return cell
        }
    }
    
    private func createBigVenueTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, recommendation: Recommendation) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BigVenueCell.reuseIdentifier, for: indexPath) as? BigVenueCell {
            cell.configureWithRecommendation(recommendation: recommendation)
            cell.addVenueAction = { [weak self] in
                self?.viewModel.fetchVenue(id: recommendation.id, forMenu: true)
            }
            cell.likeVenueAction = { [weak self] in
                self?.likeVenue(indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    private func createCollectionViewContainerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CollectionViewContainerCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerCell.reuseIdentifier, for: indexPath) as? CollectionViewContainerCell {
            cell.collectionView.register(UINib(nibName: SmallVenueCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: SmallVenueCell.reuseIdentifier)
            cell.collectionView.register(UINib(nibName: PlaylistCompactCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: PlaylistCompactCell.reuseIdentifier)
            return cell
        }
        return CollectionViewContainerCell()
    }
    
    private func createPlaylistTileCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, recommendation: Recommendation) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTileCell.reuseIdentifier, for: indexPath) as? PlaylistTileCell {
            cell.configureWithRecommendation(recommendation: recommendation)
            cell.likePlaylistAction = { [weak self] in
                self?.likePlaylist(indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// -------------------------------------
// MARK: - UITableViewDelegate
// -------------------------------------
extension LandingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let recommendationsList = viewModel.recommendations?.data[section] else {
            return nil
        }
        return headerViewWithTitle(title: recommendationsList.title)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CollectionViewContainerCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        tableViewCell.collectionViewOffset = storedOffsets[tableViewCell.collectionView.tag]?[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CollectionViewContainerCell else { return }
        storedOffsets[tableViewCell.collectionView.tag] = [indexPath.row: tableViewCell.collectionViewOffset]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = viewModel.recommendations?.data[indexPath.section].recommendations[indexPath.row].id, let type = viewModel.recommendations?.data[indexPath.section].type else {
            return
        }
        
        switch type {
        case RecommendationsType.venue.rawValue:
            navigateToVenueControllerWith(venueId: id)
        case RecommendationsType.playlist.rawValue:
            navigateToPlaylistControllerWith(playlistId: id)
        default:
            print("unhandled type: \(type) tapped")
        }
    }
    
    private func headerViewWithTitle(title: String?) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTitleView.reuseIdentifier)
        if let headerView = headerView as? HeaderTitleView {
            headerView.title = title
        }
        return headerView
    }
    
}

// -------------------------------------
// MARK: - UICollectionViewDataSource
// -------------------------------------
extension LandingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //using collectionView.tag is used to get the right section at this position. Tag is set, when the tableview cell is configured.
        let recommendations = viewModel.recommendations?.data[collectionView.tag].recommendations
        let recommendationsCount = recommendations?.count ?? 0
        return recommendationsCount > 0 ? recommendationsCount - 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let recommendationsList = viewModel.recommendations?.data[collectionView.tag] else {
            return UICollectionViewCell()
        }
        
        let recommendations = recommendationsList.recommendations
        if recommendationsList.type == RecommendationsType.playlist.rawValue {
            return createPlaylistCompactCell(collectionView, cellForItemAt: indexPath, recommendation: recommendations[indexPath.row+1])
        }
        if recommendationsList.type == RecommendationsType.venue.rawValue {
            return createSmallVenueCell(collectionView, cellForItemAt: indexPath, recommendation: recommendations[indexPath.row+1])
        }
        return UICollectionViewCell()
    }
    
    private func createSmallVenueCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath,
                                      recommendation: Recommendation) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallVenueCell.reuseIdentifier, for: indexPath) as? SmallVenueCell {
            
            cell.addVenueAction = { [weak self] in
                self?.viewModel.fetchVenue(id: recommendation.id, forMenu: true)
            }
            cell.likeVenueAction = { [weak self] in
                let venueIndexPath = IndexPath(row: indexPath.row + 1, section: collectionView.tag)
                self?.likeVenue(venueIndexPath)
            }
            cell.configureWithRecommendation(recommendation: recommendation)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func createPlaylistCompactCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, recommendation: Recommendation) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCompactCell.reuseIdentifier, for: indexPath) as? PlaylistCompactCell {
            cell.configureWithRecommendation(recommendation: recommendation)
            
            cell.likePlaylistAction = { [weak self] in
                let playlistIndexPath = IndexPath(row: indexPath.row + 1, section: collectionView.tag)
                self?.likePlaylist(playlistIndexPath)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// -------------------------------------
// MARK: - UICollectionViewDelegate
// -------------------------------------
extension LandingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let recommendationsList = viewModel.recommendations?.data[collectionView.tag] else {
            return
        }
        let recommendations = recommendationsList.recommendations
        let recommendationIndex = indexPath.row + 1 // collecttionView starts with second item in array
        let recommendationId = recommendations[recommendationIndex].id
        if recommendationsList.type == RecommendationsType.playlist.rawValue {
            navigateToPlaylistControllerWith(playlistId: recommendationId)
        } else if recommendationsList.type == RecommendationsType.venue.rawValue {
            navigateToVenueControllerWith(venueId: recommendationId)
        }
    }
}

// -------------------------------------
// MARK: - Venue menu Delegate
// -------------------------------------
extension LandingViewController: VenueMenuProtocol {
    func openAddCaptionViewController(venue: Venue) {
        openEditViewController(field: .venueCaption, venue: venue)
    }
    func openCreateListViewController(venue: Venue) {
        openEditViewController(field: .newList, venue: venue)
    }
    func venueMenueAPIFail(error: Error) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Got it"), negativeButtonText: "")
        
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        view.addSubview(actionPopupView)
    }
}

// -------------------------------------
// MARK: - Edit Playlist Delegate
// -------------------------------------
extension LandingViewController: EditPlaylistProtocol {
    func openEditViewController(field: PlaylistField, venue: Venue? = nil) {
        let editViewController = EditPlaylistFieldViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.EditPlaylistFieldViewController)
        let editViewModel = EditPlaylistFieldViewModel(withField: field, playlist: nil)
        editViewModel.editDelegate = editViewController
        editViewModel.venue = venue
        editViewController.viewModel = editViewModel
        editViewController.delegate = self
        navigationController?.pushViewController(editViewController, animated: true)
    }
}

// -------------------------------------
// MARK: - Playlist Delegate
// -------------------------------------
extension LandingViewController: PlaylistDelegate {
    func didDeletePlaylist(playlistId: String) {
        viewModel.callRecommendationsAPI(isForTableView: true)
    }
}

// -------------------------------------
// MARK: - PlaylistDetail Delegate
// -------------------------------------
extension LandingViewController: PlaylistDetailsDataDelegate {
    func didReceiveData(playlistResponse: Playlist) {
        let vc = PlaylistViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.PlaylistViewController)
        let vm = PlaylistViewModel(playlist: playlistResponse)
        vc.delegate = self
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
