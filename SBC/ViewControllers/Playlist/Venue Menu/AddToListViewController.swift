import UIKit

class AddToListViewController: UIViewController {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var createPlaylistButton: UIButton!
    @IBOutlet private weak var noPlaylistLabel: UILabel!
    @IBOutlet private weak var noPlaylistView: UIView!
    @IBOutlet private weak var playlistTableView: UITableView!
    @IBOutlet private weak var playlistTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    weak var delegate: VenueMenuProtocol?
    var viewModel: AddToListViewModelProtocol?
    var showMoreButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupUI()
        viewModel?.callPlaylistsAPI()
    }
    
    private func setupUI() {
        contentViewBottomConstraint.constant = UIDevice.current.hasNotch ? 24 : 0
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: "addToList_title".localized(bundle: Bundle.main), fontSize: 16, textAlignment: .center))
        
        createPlaylistButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "create_list_title")))
        createPlaylistButton.setImage(UIImage(named: "coreIconPlaylist"), for: .normal)
        createPlaylistButton.tintColor = UIColor(colorConfig.primary_button_color!)
        
        noPlaylistLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: localizedStringForKey(key: "create_list_no_playlist"), fontSize: 12, textColor: UIColor(colorConfig.edit_field_secondary_text_color!), numberOfLines: 0))
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: playlistTableView.frame.width, height: 56))
        let myListLabel = UILabel(frame: CGRect(x: 0, y: 40, width: playlistTableView.frame.width, height: 16))
        myListLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: localizedStringForKey(key: "addTo_list_header"), fontSize: 12, textColor: UIColor.themeDarkBlueTint1))
        tableHeaderView.addSubview(myListLabel)
        playlistTableView.tableHeaderView = tableHeaderView
        
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: playlistTableView.frame.width, height: 66))
        showMoreButton = UIButton(frame: CGRect(x: 0, y: 16, width: 110, height: 24))
        showMoreButton.setImage(UIImage(named: "coreIconChevDown"), for: .normal)
        showMoreButton.setImage(UIImage(named: "coreIconChevUp"), for: .selected)
        showMoreButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "addTo_list_showMore_button")))
        showMoreButton.setTitle(localizedStringForKey(key: "addTo_list_showMore_button"), for: .normal)
        showMoreButton.setTitle(localizedStringForKey(key: "addTo_list_showLess_button"), for: .selected)
        showMoreButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        showMoreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        showMoreButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(_:)), for: .touchUpInside)
        tableFooterView.addSubview(showMoreButton)
        playlistTableView.tableFooterView = tableFooterView
        playlistTableView.estimatedRowHeight = 0
        playlistTableView.estimatedSectionHeaderHeight = 0
        playlistTableView.estimatedSectionFooterHeight = 0
    }
    
    @IBAction private func closeAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
    
    @IBAction private func showMoreButtonTapped(_ sender: Any) {
        showMoreButton.isSelected = !showMoreButton.isSelected
        playlistTableView.reloadData()
        playlistTableViewHeightConstraint.constant =  min(playlistTableView.contentSize.height, UIScreen.main.bounds.height - 160)

        playlistTableView.isScrollEnabled = playlistTableView.contentSize.height >= UIScreen.main.bounds.height - 160
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction private func createListAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate, let venue = viewModel?.venue {
            delegate.openCreateListViewController(venue: venue)
            parent.dismissViewController()
        }
    }
    private func registerNib() {
        playlistTableView.separatorStyle = .none
        playlistTableView.register(UINib(nibName: "PlaylistTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "playlistCell")
    }
}

extension AddToListViewController: PlaylistsDataDelegate {
    func didReceiveData(playlistResponse: Playlists) {
        if playlistResponse.count == 0 {
            noPlaylistView.isHidden = false
            playlistTableView.isHidden = true
        } else {
            noPlaylistView.isHidden = true
            playlistTableView.isHidden = false
            if playlistResponse.count <= 4 {
                playlistTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 16))
            }
            playlistTableView.reloadData()
            playlistTableView.layoutIfNeeded()
            playlistTableView.isScrollEnabled = false
            playlistTableViewHeightConstraint.constant =  playlistTableView.contentSize.height
        }
    }
    
    func failureWithError(message: String) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Try again"), negativeButtonText: "Cancel")
        
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: false)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction = { [weak self] in
            self?.viewModel?.callPlaylistsAPI()
        }
        parent?.view.addSubview(actionPopupView)
    }
    
    func didAddVenue(venue: Venue, toPlaylist: Playlist) {
        AlertViewAdapter.shared.showBottomMessageWithDismiss(localizedStringForKey(key: "addTo_list_success_title"), details: String(format: localizedStringForKey(key: "addTo_list_success"), venue.name, toPlaylist.title ?? "playlist"), state: .success)
        if let parent = parent as? BottomSheetViewController {
                   parent.dismissViewController()
               }
    }
    
    func closeWithFailure(error: APIError) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate {
            delegate.venueMenueAPIFail(error: error)
            parent.dismissViewController()
        }
    }
}

extension AddToListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel, let playlists = viewModel.playlists {
            if playlists.count > 4 && !showMoreButton.isSelected {
                return 4
            }
            return playlists.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        if let viewModel = viewModel, let playlists = viewModel.playlists, let data = playlists.data {
            cell.configureWithPlaylist(playlist: data[indexPath.row], venue: viewModel.venue)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel, let playlists = viewModel.playlists, let data = playlists.data {
            viewModel.addVenueToPlaylistAPI(playlist: data[indexPath.row])
        }
    }
    
}
