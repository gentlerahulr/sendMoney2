//
//  YourLikesViewController.swift
//  SBC
//

import UIKit

class YourLikesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var skeletonView: SkeletonViewLanding?
    private var emptyView: YourLikesEmptyView?
    
    var viewModel: YourLikesViewModel?
    private var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton(screenTitle: "YOUR_LIKES".localized(bundle: Bundle.main), screenTitleColor: colorConfig.navigation_header_color )
        setupTableView()
        scrollView.delegate = self
        setupNavigation()
        addSkeletonView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadRemoteData()
    }
    
    private func showEmptyStateView() {
        
        if let emptyView = emptyView {
            tableView.showEmptyStateView(emptyView)
            emptyView.buttonAction = startExploringTapped
        } else {
            emptyView = UIView.fromNib(YourLikesEmptyView.nibName) as? YourLikesEmptyView
            showEmptyStateView()
        }
        scrollView.isScrollEnabled = false
        
    }
    
    private func removeEmptyView() {
        tableView.removeEmptyState()
        emptyView?.removeFromSuperview()
        emptyView = nil
        scrollView.isScrollEnabled = true
    }
    
    private func startExploringTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
        showScreenTitleWithLeftBarButton(screenTitleColor: colorConfig.dark_navigation_header_text_color)
        showRightBarButton(arrOfRightButtonConfig: [NavButtonConfig(font: nil, textColor: nil, backgroundColor: nil, borderColor: nil, cornerRadius: 0, image: UIImage(named: "coreIconLike"), imageTintColor: .white, title: nil, frame: nil)])
        IBViewTop.setLeftButtonColor(color: UIColor.white)
        IBViewTop.hideRightButton()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PlaylistTileCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: PlaylistTileCell.reuseIdentifier)
        tableView.register(HeaderTitleButtonView.self, forHeaderFooterViewReuseIdentifier: HeaderTitleButtonView.reuseIdentifier)
        tableView.register(HeaderTitleView.self, forHeaderFooterViewReuseIdentifier: HeaderTitleView.reuseIdentifier)
        tableView.register(UINib(nibName: BigVenueCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: BigVenueCell.reuseIdentifier)
        tableView.register(UINib(nibName: CollectionViewContainerCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: CollectionViewContainerCell.reuseIdentifier)
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        footer.backgroundColor = .white
        tableView.tableFooterView = footer
        
        tableView.separatorStyle = .none
    }
    
    private func setupConstraints() {
        tableViewHeightConstraint.constant = min(self.view.frame.height - IBViewTop.frame.height, tableView.contentSize.height)
    }
    
    private func navigateToVenueControllerWith(venue: Venue) {
        let vc = VenueDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.VenueDetailsViewController)
        let vm = VenueDetailsViewModel(venueId: venue.id)
        vc.viewModel = vm
        vc.viewModel?.delegate = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToPlaylistController(playlistId: String) {
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
        if let indexPath = indexPath, var venue = viewModel?.venues?.data[indexPath.row] {
            venue.isLiked = !venue.isLiked
            let toAdd = venue.isLiked ? 1 : -1
            venue.likeCount += toAdd
            viewModel?.venues?.data[indexPath.row] = venue
            tableView.reloadData()
        }
        viewModel?.likeVenue(indexPath: indexPath)
    }
    
    private func likePlaylist(_ indexPath: IndexPath?) {
        if let indexPath = indexPath, var playlist = viewModel?.playlists?.data?[indexPath.row] {
            playlist.isLiked = !playlist.isLiked
            let toAdd = playlist.isLiked ? 1 : -1
            playlist.likeCount += toAdd
            viewModel?.playlists?.data?[indexPath.row] = playlist
            tableView.reloadData()
        }
        viewModel?.likePlaylist(indexPath: indexPath)
    }
    
}

// -------------------------------------
// MARK: - SkeletonControl
// -------------------------------------
extension YourLikesViewController {
    
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
// MARK: - UITableViewDataSource
// -------------------------------------
extension YourLikesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel?.venues?.count ?? 0 == 0 && viewModel?.playlists?.count ?? 0 == 0 {
            showEmptyStateView()
        } else {
            removeEmptyView()
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let venuesCount = viewModel?.venues?.count ?? 0
            return venuesCount > 1 ? 2 : venuesCount
        default:
            return viewModel?.playlists?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return createBigVenueTableViewCell(tableView, cellForRowAt: indexPath)
            default:
                return createCollectionViewContainerCell(tableView, cellForRowAt: indexPath)
            }
        default:
            return createPlaylistTileCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func createBigVenueTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BigVenueCell.reuseIdentifier, for: indexPath) as? BigVenueCell {
            if let viewModel = viewModel, let venues = viewModel.venues {
                
                cell.addVenueAction = { [weak self] in
                    self?.openVenueMenu(venue: venues.data[indexPath.row])
                }
                cell.likeVenueAction = { [weak self] in
                    self?.likeVenue(indexPath)
                }
                cell.configureWithVenue(venue: venues.data[indexPath.row])
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
            return cell
        }
        return UITableViewCell()
    }
    
    private func createCollectionViewContainerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerCell.reuseIdentifier, for: indexPath) as? CollectionViewContainerCell {
            cell.collectionView.register(UINib(nibName: SmallVenueCell.nibName, bundle: Bundle.main),
                                         forCellWithReuseIdentifier: SmallVenueCell.reuseIdentifier)
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
            return cell
        }
        return UITableViewCell()
    }
    
    private func createPlaylistTileCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTileCell.reuseIdentifier, for: indexPath) as? PlaylistTileCell {
            if let playlistsData = viewModel?.playlists?.data {
                cell.configureWithPlaylist(playlist: playlistsData[indexPath.row], forLike: true)
                cell.likePlaylistAction = { [weak self] in
                    self?.likePlaylist(indexPath)
                }
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
            return cell
        }
        return UITableViewCell()
    }
}

// -------------------------------------
// MARK: - UITableViewDelegate
// -------------------------------------
extension YourLikesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0, let venue = viewModel?.venues?.data[0] {
                navigateToVenueControllerWith(venue: venue)
            }
            //second row is a container for collectionview. Handled in UICollectionViewDelegate
        default:
            if let playlistId = viewModel?.playlists?.data?[indexPath.row].id {
                navigateToPlaylistController(playlistId: playlistId)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if viewModel?.venues?.data.count ?? 0 > 0 {
            let buttonTitle = "YOUR_LIKES_VIEW_ALL".localized(bundle: Bundle.main)
            return headerViewWithTitleAndButton(title: viewModel?.likedVenuesSectionTitle, notSelectedStateTitle: buttonTitle, selectedStateTitle: buttonTitle)
            }
        default:
            if viewModel?.playlists?.data?.count ?? 0 > 0 {
            return headerViewWithTitle(title: viewModel?.likedPlaylistsSectionTitle)
            }
        }
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && viewModel?.venues?.data.count ?? 0 > 0 {
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        }
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //horizontal collectionview - offset adjustment
        if let tableViewCell = cell as? CollectionViewContainerCell {
            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }

        if let playlistsDataCount = viewModel?.playlists?.count {
            if indexPath.section == 1 && indexPath.row+1 == playlistsDataCount && viewModel?.playlists?.nextPageToken != nil {
                viewModel?.loadAdditionalPlaylistData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CollectionViewContainerCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if viewModel?.venues?.count ?? 0 == 0 && section == 0 || (viewModel?.playlists?.count ?? 0 == 0 && section == 1) {
            return 0
        }
        return 50
    }
    
    private func headerViewWithTitleAndButton(title: String?, notSelectedStateTitle: String?, selectedStateTitle: String?) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTitleButtonView.reuseIdentifier) as? HeaderTitleButtonView {
            headerView.title = title
            headerView.buttonNotSelectedStateTitle = notSelectedStateTitle
            headerView.buttonSelectedStateTitle = selectedStateTitle
            headerView.buttonAction = { [weak self] in
                self?.navigateToAllPlaylists()
            }
            return headerView
        }
        return nil
    }
    
    private func headerViewWithTitle(title: String?) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTitleView.reuseIdentifier)
        if let headerView = headerView as? HeaderTitleView {
            headerView.title = title
            return headerView
        }
        return nil
    }
    
    private func navigateToAllPlaylists() { //selectionEnabled: Bool
        let vc = PlaylistViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.PlaylistViewController)
        let vm = PlaylistViewModel(forLikeVenues: true)
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// -------------------------------------
// MARK: - UICollectionViewDataSource
// -------------------------------------
extension YourLikesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let venueCount = viewModel?.venues?.data.count ?? 0
        return  venueCount > 0 ? venueCount - 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallVenueCell.reuseIdentifier, for: indexPath) as? SmallVenueCell {
            if let viewModel = viewModel, let venues = viewModel.venues {
            cell.addVenueAction = { [weak self] in
                self?.openVenueMenu(venue: venues.data[indexPath.row+1])
            }
            cell.likeVenueAction = { [weak self] in
                let venueIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                self?.likeVenue(venueIndexPath)
            }
                cell.configureWithVenue(venue: venues.data[indexPath.row+1])
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// -------------------------------------
// MARK: - UICollectionViewDelegate
// -------------------------------------
extension YourLikesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let venueIndex = indexPath.row + 1 // collecttionView starts with second item in array
        if let venue = viewModel?.venues?.data[venueIndex] {
            navigateToVenueControllerWith(venue: venue)
        }
    }
}

// -------------------------------------
// MARK: - YourLikesDataDelegate
// -------------------------------------
extension YourLikesViewController: YourLikesDataDelegate {
    
    func failureWithError(message: String) {
        tableView.reloadData()
        hideSkeletonView()
    }
    
    func didReceiveData() {
        tableView.reloadData()
        hideSkeletonView()
    }
    
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?) {
        if error != nil {
            if let indexPath = indexPath {
                if var playlist = viewModel?.playlists?.data?[indexPath.row] {
                    playlist.isLiked = !playlist.isLiked
                    let toAdd = playlist.isLiked ? 1 : -1
                    playlist.likeCount += toAdd
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        hideSkeletonView()
    }
    
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?) {
        if error != nil {
            if let indexPath = indexPath {
                if var venue = viewModel?.venues?.data[indexPath.row] {
                    venue.isLiked = !venue.isLiked
                    let toAdd = venue.isLiked ? 1 : -1
                    venue.likeCount += toAdd
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}

// -------------------------------------
// MARK: - Venue menu Delegate
// -------------------------------------
extension YourLikesViewController: VenueMenuProtocol {
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
extension YourLikesViewController: EditPlaylistProtocol {
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
// MARK: - Scroll View Delegate
// -------------------------------------
extension YourLikesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y  >= navigationController?.navigationBar.frame.height ?? 44 {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: "YOUR_LIKES".localized(bundle: Bundle.main))
                    self.IBViewTop.backgroundColor = UIColor.themeDarkBlue
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: "")
                    self.IBViewTop.backgroundColor = .clear
                    self.IBViewTop.hideRightButton()
                }
            }
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y + 10 >= headerView.frame.height) || (self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.frame.height)
        }
        if scrollView == tableView {
            tableView.isScrollEnabled = tableView.contentOffset.y > 0
        }
    }
}

// -------------------------------------
// MARK: - Playlist Delegate
// -------------------------------------
extension YourLikesViewController: PlaylistDelegate {
    func didDeletePlaylist(playlistId: String) {
        viewModel?.loadRemoteData()
    }
}

// -------------------------------------
// MARK: - PlaylistDetail Delegate
// -------------------------------------
extension YourLikesViewController: PlaylistDetailsDataDelegate {
    func didReceiveData(playlistResponse: Playlist) {
        let vc = PlaylistViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.PlaylistViewController)
        let vm = PlaylistViewModel(playlist: playlistResponse)
        vc.delegate = self
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
