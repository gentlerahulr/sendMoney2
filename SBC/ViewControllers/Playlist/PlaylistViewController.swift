import UIKit

protocol PlaylistDelegate: AnyObject {
    func didDeletePlaylist(playlistId: String)
}

class PlaylistViewController: BaseViewController {
    
    enum SegueIdentifier {
        static let editDescription = "editDescription"
    }
    
    @IBOutlet weak private var playlistImageView: UIImageView!
    @IBOutlet weak private var venuesTableView: UITableView!
    @IBOutlet weak private var venuesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var headerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var scrollViewContentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var playlistDetailView: UIStackView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var likeCountButton: UIButton!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var lastUpdatedLabel: UILabel!
    
    @IBOutlet weak private var profileView: UIView!
    @IBOutlet weak private var creatorImageView: UIImageView!
    @IBOutlet weak private var creatorTitleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    @IBOutlet weak private var placesLabel: UILabel!
    @IBOutlet weak private var placesTitleLabel: UILabel!
    
    @IBOutlet weak private var skeletonView: UIView!
    
    @IBOutlet weak private var addDescriptionView: UIView!
    @IBOutlet weak private var addDescriptionButton: UIButton!
    @IBOutlet weak private var descriptionView: UIView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    weak var delegate: PlaylistDelegate?
    
    var viewModel: PlaylistViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonView.showSkeleton()
        playlistImageView.applyVerticalGradient(colours: [UIColor.themeDarkBlue, UIColor.themeDarkBlue.withAlphaComponent(0)])
        registerNib()
        setupNavigation()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 34))
        tableFooter.backgroundColor = .white
        venuesTableView.tableFooterView = tableFooter
        scrollViewContentViewBottomConstraint.constant = UIDevice.current.hasNotch ? 34 : 0
        
        if viewModel?.playlist != nil && skeletonView != nil {
            skeletonView.hideSkeleton()
            skeletonView.removeFromSuperview()
            setupBindings()
        }
    }
    
    private func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        showScreenTitleWithLeftBarButton(screenTitleColor: colorConfig.dark_navigation_header_text_color)
        showRightBarButton(arrOfRightButtonConfig: [NavButtonConfig(font: nil, textColor: nil, backgroundColor: nil, borderColor: nil, cornerRadius: 0, image: UIImage(named: "coreIconLike"), imageTintColor: .white, title: nil, frame: nil)])
        IBViewTop.setLeftButtonColor(color: UIColor.white)
        IBViewTop.hideRightButton()
    }
    
    private func setupAddDescriptionButton() {
        addDescriptionButton.setButtonConfig(btnConfig: viewModel?.btnAddDescriptionConfig)
        addDescriptionButton.titleLabel?.numberOfLines = 0
        addDescriptionButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addDescriptionButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addDescriptionButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addDescriptionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: addDescriptionButton.frame.width - (addDescriptionButton.titleLabel?.frame.width)! - 70, bottom: 0, right: 0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func registerNib() {
        venuesTableView.separatorStyle = .none
        venuesTableView.register(UINib(nibName: "VenueTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "venueCell")
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        footer.backgroundColor = .white
        venuesTableView.tableFooterView = footer
    }
    
    fileprivate func setupCreator(_ playlist: Playlist, _ viewModel: PlaylistViewModel) {
        if let creator = playlist.creator {
            creatorLabel.text = viewModel.isMyPlaylist ? "me" : creator.username
            if let creatorPicture = creator.profilePictureUrl {
                creatorImageView.downloaded(from: creatorPicture)
            }
        } else {
            creatorLabel.text = "ONZ"
            creatorImageView.image = UIImage(named: "onzAppIcon") 
        }
        creatorTitleLabel.setLabelConfig(lblConfig: viewModel.lblCreatedByConfig)
        placesTitleLabel.setLabelConfig(lblConfig: viewModel.lblPlacesConfig)
    }
    
    fileprivate func setupHeader(_ playlist: Playlist) {
        titleLabel.text = playlist.title
        subtitleLabel.text = playlist.subtitle
        likeCountButton.setTitle("\(playlist.likeCount)", for: .normal)
        likeCountButton.isSelected = playlist.isLiked
        placesLabel.text = "\(playlist.placeCount)"
        if let venues = playlist.venues {
            if venues.count > 0 {
                
                if let imageUrl = venues.data[0].imageUrl {
                    playlistImageView.downloaded(from: imageUrl)
                    playlistImageView.blurImage()
                } else {
                    playlistImageView.image = nil
                }
                if venues.count == 1 {
                    placesTitleLabel.text = NSLocalizedString("playlist_label_place", comment: "")
                }
            }
        }
        if let lastDate = playlist.updated {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd MMM YYYY"
            lastUpdatedLabel.text =  "Last updated \(dateFormat.string(from: lastDate))"
        }
        headerView.layoutSubviews()
    }
    
    fileprivate func setupDescription(_ playlist: Playlist, _ viewModel: PlaylistViewModel) {
        if let description = playlist.description, !description.isEmpty {
            descriptionLabel.text = description
            addDescriptionView.isHidden = true
            descriptionView.isHidden = false
        } else if viewModel.isMyPlaylist {
            setupAddDescriptionButton()
            addDescriptionView.isHidden = false
            descriptionView.isHidden = true
        } else {
            addDescriptionView.isHidden = true
            descriptionView.isHidden = true
        }
    }
    
    fileprivate func setupPlaylist(_ playlist: Playlist, _ viewModel: PlaylistViewModel) {
        IBViewTop.setRightButtonImage(image: UIImage(named: playlist.isLiked  ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
        setupDescription(playlist, viewModel)
        editButton.isHidden = !viewModel.isMyPlaylist
        setupCreator(playlist, viewModel)
        setupHeader(playlist)
        view.layoutSubviews()
        venuesTableView.reloadData()
        venuesTableView.layoutIfNeeded()
        venuesTableViewHeightConstraint.constant = min(self.view.frame.height - IBViewTop.frame.height, venuesTableView.contentSize.height)
    }
    
    fileprivate func setupLikedVenues(_ venues: Venues) {
        IBViewTop.hideRightButton()
        titleLabel.text = localizedStringForKey(key: "likedVenues_label_title")
        subtitleLabel.text = localizedStringForKey(key: "likedVenues_label_subtitle")
        likeCountButton.isHidden = true
        editButton.isHidden = true
        profileView.isHidden = true
        addDescriptionView.isHidden = true
        descriptionView.isHidden = true
        if venues.count > 0 {
            if let imageUrl = venues.data[0].imageUrl {
                playlistImageView.downloaded(from: imageUrl)
                playlistImageView.blurImage()
            }
            if venues.count == 1 {
                placesTitleLabel.text = NSLocalizedString("playlist_label_place", comment: "")
            }
        }
        if let lastDate = venues.updated {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd MMM YYYY"
            lastUpdatedLabel.text =  "Last updated \(dateFormat.string(from: lastDate))"
        }
        headerView.layoutSubviews()
        view.layoutSubviews()
        venuesTableView.reloadData()
        venuesTableView.layoutIfNeeded()
        venuesTableViewHeightConstraint.constant = min(self.view.frame.height - IBViewTop.frame.height, venuesTableView.contentSize.height)
    }
    
    private func setupBindings() {
        if let viewModel = viewModel, let playlist = viewModel.playlist {
            setupPlaylist(playlist, viewModel)
        } else if let viewModel = viewModel, let venues = viewModel.venues {
            setupLikedVenues(venues)
        }
    }
    
    // -------------------------------------
    // MARK: - Actions
    // -------------------------------------
    
    override func rightButtonAction(button: UIButton) {
        likeTapped(button)
    }
    
    @IBAction private func likeTapped(_ sender: Any) {
        likeCountButton.isSelected = !(likeCountButton.isSelected)
        IBViewTop.setRightButtonImage(image: UIImage(named: likeCountButton.isSelected ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
        let toAdd = likeCountButton.isSelected ? 1 : -1
        if let viewModel = viewModel, var playlist = viewModel.playlist {
            playlist.likeCount += toAdd
            self.viewModel?.playlist?.likeCount = playlist.likeCount
            likeCountButton.setTitle("\(playlist.likeCount)", for: .normal)
        }
        viewModel?.likePlaylistAPI()
    }
    
    @IBAction private func editPlaylistTapped(_ sender: Any) {
        let editPlaylist = EditPlaylistViewController()
        editPlaylist.delegate = self
        editPlaylist.deleteDelegate = self
        editPlaylist.playlist = viewModel?.playlist
        let bottomSheetVC = BottomSheetViewController(childViewController: editPlaylist)
        self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.editDescription {
            if let viewModel = viewModel, let playlist = viewModel.playlist {
                let editFieldViewController = segue.destination as! EditPlaylistFieldViewController
                let editViewModel = EditPlaylistFieldViewModel(withField: .description, playlist: playlist)
                editViewModel.editDelegate = editFieldViewController
                editFieldViewController.viewModel = editViewModel
                editFieldViewController.delegate = self
            }
        }
    }
}

// -------------------------------------
// MARK: - Edit Playlist Delegate
// -------------------------------------
extension PlaylistViewController: EditPlaylistProtocol {
    func openEditViewController(field: PlaylistField, venue: Venue? = nil) {
        if let viewModel = viewModel, let playlist = viewModel.playlist {
            let editViewController = EditPlaylistFieldViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.EditPlaylistFieldViewController)
            let editViewModel = EditPlaylistFieldViewModel(withField: field, playlist: playlist)
            editViewModel.editDelegate = editViewController
            editViewModel.venue = venue
            editViewController.viewModel = editViewModel
            editViewController.delegate = self
            navigationController?.pushViewController(editViewController, animated: true)
        }
    }
    
    func deletePlaylist() {
        viewModel?.deletePlaylistAPI()
    }
}

// -------------------------------------
// MARK: - Delete Delegate
// -------------------------------------
extension PlaylistViewController: DeleteFieldProtocol {
    func delete(field: DeleteField, venue: Venue?) {
        switch field {
        case .playlist, .playlistAndVenue:
            viewModel?.deletePlaylistAPI()
        case .venue:
            if let venue = venue {
                viewModel?.deleteVenueFromPlaylistAPI(venue: venue)
            }
        }
    }
}

// -------------------------------------
// MARK: - Venue menu Delegate
// -------------------------------------
extension PlaylistViewController: VenueMenuProtocol {
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
// MARK: - Scroll View Delegate
// -------------------------------------
extension PlaylistViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y >= playlistDetailView.frame.height / 4 {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: self.titleLabel.text ?? "")
                    self.IBViewTop.backgroundColor = UIColor.themeDarkBlue
                    if self.viewModel?.playlist != nil {
                        self.IBViewTop.showRightButton()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: "")
                    self.IBViewTop.backgroundColor = .clear
                    self.IBViewTop.hideRightButton()
                }
            }
            venuesTableView.isScrollEnabled = (self.scrollView.contentOffset.y + 10 >= headerView.frame.height) || (self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.frame.height)
        }
        if scrollView == venuesTableView {
            venuesTableView.isScrollEnabled = venuesTableView.contentOffset.y > 0
        }
    }
}

// -------------------------------------
// MARK: - Table View Delegate
// -------------------------------------
extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! VenueTableViewCell
        if let viewModel = viewModel, let venues = viewModel.venues {
            cell.readMoreAction = { [weak self] in
                self?.readMoreTapped(indexPath: indexPath)
            }
            cell.addVenueAction = { [weak self] in
                self?.openVenueMenu(venue: venues.data[indexPath.row])
            }
            cell.likeVenueAction = { [weak self] in
                self?.likeVenueTapped(indexPath: indexPath)
            }
            cell.configureWithVenue(venue: venues.data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.venues?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel, let venues = viewModel.venues {
            let vc = VenueDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.VenueDetailsViewController)
            let vm = VenueDetailsViewModel(venueId: venues.data[indexPath.row].id)
            vc.viewModel = vm
            vm.delegate = vc
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func readMoreTapped(indexPath: IndexPath) {
        venuesTableView.beginUpdates()
        venuesTableView.endUpdates()
    }
    
    private func openVenueMenu(venue: Venue) {
        if let viewModel = viewModel, viewModel.isMyPlaylist {
            let venueMenuVC = VenueMenuViewController()
            venueMenuVC.delegate = self
            venueMenuVC.deleteDelegate = self
            venueMenuVC.venue = venue
            venueMenuVC.currentPlaylist = viewModel.playlist
            let bottomSheetVC = BottomSheetViewController(childViewController: venueMenuVC)
            self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
            
        } else {
            let addToPlaylistVC = AddToListViewController()
            addToPlaylistVC.delegate = self
            let addToListVM = AddToListViewModel(venue: venue)
            addToListVM.delegate = addToPlaylistVC
            addToPlaylistVC.viewModel = addToListVM
            let bottomSheetVC = BottomSheetViewController(childViewController: addToPlaylistVC)
            self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
        }
    }
    
    private func likeVenueTapped(indexPath: IndexPath) {
        if var venue = viewModel?.venues?.data[indexPath.row] {
            venue.isLiked = !venue.isLiked
            let toAdd = venue.isLiked ? 1 : -1
            venue.likeCount += toAdd
            viewModel?.venues?.data[indexPath.row] = venue
        }
        venuesTableView.reloadRows(at: [indexPath], with: .automatic)
        if let viewModel = viewModel {
            viewModel.likeVenue(indexPath: indexPath)
            if viewModel.isLikedVenues {
                viewModel.venues?.data.remove(at: indexPath.row)
                if viewModel.venues?.data.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    venuesTableView.reloadData()
                }
            }
        }
    }
}

extension PlaylistViewController: PlaylistDetailsDataDelegate {
    func failureWithError(message: String) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Ok"), negativeButtonText: "")
        
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(actionPopupView)
    }
    
    func didReceiveData(playlistResponse: Playlist) {
        viewModel?.playlist = playlistResponse
        viewModel?.venues = playlistResponse.venues
        setupBindings()
        if skeletonView != nil {
            skeletonView.hideSkeleton()
            skeletonView.removeFromSuperview()
        }
    }
    
    func didReceiveData(venuesResponse: Venues) {
        setupBindings()
        if skeletonView != nil {
            skeletonView.hideSkeleton()
            skeletonView.removeFromSuperview()
        }
    }
    
    func didDeletePlaylist(error: APIError?) {
        if error != nil {
            let actionPopupView = ActionPopup()
            let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Got it"), negativeButtonText: "")
            let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
            actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
            view.addSubview(actionPopupView)
        } else {
            if let delegate = delegate, let playlistId = viewModel?.playlistId {
                delegate.didDeletePlaylist(playlistId: playlistId)
            }
            self.navigationController?.popToRootViewController(animated: true)
            AlertViewAdapter.shared.showBottomMessageWithDismiss(localizedStringForKey(key: "list_deleted_title"), details: String(format: localizedStringForKey(key: "list_deleted"), viewModel?.playlist?.title ?? ""), state: .success)
        }
    }
    
    func didDeleteVenue(venue: Venue, error: APIError?) {
        if error != nil {
            let actionPopupView = ActionPopup()
            let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Got it"), negativeButtonText: "")
            let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
            actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
            actionPopupView.addPositiveButtonAction = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            view.addSubview(actionPopupView)
        } else {
            AlertViewAdapter.shared.showBottomMessageWithDismiss(localizedStringForKey(key: "place_deleted_title"), details: String(format: localizedStringForKey(key: "place_deleted"), venue.name, viewModel?.playlist?.title ?? ""), state: .success)
            if let viewModel = viewModel, var venues = viewModel.venues, let index = venues.data.firstIndex(of: venue) {
                venues.data.remove(at: index)
                self.viewModel?.venues = venues
                self.viewModel?.playlist?.venues = venues
                self.viewModel?.playlist?.placeCount -= 1
                setupBindings()
            }
        }
    }
    
    func didToggleLikePlaylist(error: APIError?) {
        if error != nil {
            likeCountButton.isSelected = !(likeCountButton.isSelected)
            IBViewTop.setRightButtonImage(image: UIImage(named: likeCountButton.isSelected ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
            let toAdd = likeCountButton.isSelected ? 1 : -1
            if let viewModel = viewModel, var playlist = viewModel.playlist {
                playlist.likeCount += toAdd
                self.viewModel?.playlist?.likeCount = playlist.likeCount
                likeCountButton.setTitle("\(playlist.likeCount)", for: .normal)
            }
        }
    }
    
    func didToggleLikeVenue(indexPath: IndexPath, error: APIError?) {
        if error != nil {
            if var venue = viewModel?.venues?.data[indexPath.row] {
                venue.isLiked = !venue.isLiked
                let toAdd = venue.isLiked ? 1 : -1
                venue.likeCount += toAdd
                venuesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
