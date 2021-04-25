import UIKit

protocol VenueMenuProtocol: NSObject {
    func openAddCaptionViewController(venue: Venue)
    func openCreateListViewController(venue: Venue)
    func venueMenueAPIFail(error: Error)
}

extension VenueMenuProtocol {
    func openAddCaptionViewController(venue: Venue) {}
}

class VenueMenuViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var addCaptionButton: UIButton!
    @IBOutlet private weak var addToListButton: UIButton!
    @IBOutlet private weak var removeFromListButton: UIButton!
    var venue: Venue?
    var currentPlaylist: Playlist?
    weak var delegate: VenueMenuProtocol?
    weak var deleteDelegate: DeleteFieldProtocol?
    @IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        contentViewBottomConstraint.constant = UIDevice.current.hasNotch ? 24 : 0
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        var hasCaption = false
        if let venue = venue, let caption = venue.caption {
            hasCaption = !caption.isEmpty
        }
        addCaptionButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: hasCaption ? "editCaption_title" : "addCaption_title")))
        addCaptionButton.setImage(UIImage(named: "coreIconPlus"), for: .normal)
        addCaptionButton.tintColor = UIColor(colorConfig.primary_button_color!)
        
        addToListButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "addToList_title")))
        addToListButton.setImage(UIImage(named: "coreIconPlaylist"), for: .normal)
        addToListButton.tintColor = UIColor(colorConfig.primary_button_color!)
        
        removeFromListButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "removeFromList_title")))
        removeFromListButton.setImage(UIImage(named: "coreIconDelete"), for: .normal)
        removeFromListButton.tintColor = UIColor(colorConfig.primary_button_color!)
    }
    
    @IBAction private func closeAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
    
    @IBAction func addCaptionAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate, let venue = venue {
            delegate.openAddCaptionViewController(venue: venue)
            parent.dismissViewController()
        }
    }
    
    @IBAction func addToListAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate, let venue = venue {
            let addToListVC = AddToListViewController()
            addToListVC.delegate = delegate
            let addToListVM = AddToListViewModel(venue: venue)
            addToListVM.delegate = addToListVC
            addToListVC.viewModel = addToListVM
            parent.navigateTo(viewController: addToListVC)
        }
    }
    
    @IBAction func removeFromListAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let deleteDelegate = deleteDelegate {
            let deleteVC = DeleteBottomSheetViewController()
            deleteVC.delegate = deleteDelegate
            deleteVC.venue = venue
            deleteVC.deleteField = currentPlaylist?.placeCount == 1 ? .playlistAndVenue : .venue
            parent.navigateTo(viewController: deleteVC)
        }
    }
}
