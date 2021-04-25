import UIKit

protocol EditPlaylistProtocol: NSObject {
    func openEditViewController(field: PlaylistField, venue: Venue?)
}

class EditPlaylistViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var renameButton: UIButton!
    @IBOutlet private weak var editSubtitleButton: UIButton!
    @IBOutlet private weak var editDescriptionButton: UIButton!
    @IBOutlet private weak var deleteListButton: UIButton!
    weak var delegate: EditPlaylistProtocol?
    weak var deleteDelegate: DeleteFieldProtocol?
    @IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupButtons() {
        contentViewBottomConstraint.constant = UIDevice.current.hasNotch ? 24 : 0
        renameButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: "edit_list_rename".localized(bundle: Bundle.main)))
        renameButton.setImage(UIImage(named: "coreIconEdit"), for: .normal)
        renameButton.tintColor = UIColor(colorConfig.primary_button_color!)
        if let playlist = playlist {
            editSubtitleButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: ((playlist.subtitle == nil ) || (playlist.subtitle!.isEmpty)) ? "edit_list_add_subtitle".localized(bundle: Bundle.main) : "edit_list_edit_subtitle".localized(bundle: Bundle.main)))
            editSubtitleButton.setImage(UIImage(named: ((playlist.subtitle == nil ) || (playlist.subtitle!.isEmpty)) ? "coreIconPlus" : "coreIconEdit"), for: .normal)
            editSubtitleButton.tintColor = UIColor(colorConfig.primary_button_color!)
            
            editDescriptionButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: ((playlist.description == nil) || playlist.description!.isEmpty) ? "edit_list_add_description".localized(bundle: Bundle.main) : "edit_list_edit_description".localized(bundle: Bundle.main)))
            editDescriptionButton.setImage(UIImage(named: ((playlist.description == nil) || playlist.description!.isEmpty) ? "coreIconPlus" : "coreIconEdit"), for: .normal)
            editDescriptionButton.tintColor = UIColor(colorConfig.primary_button_color!)
            
        }
        deleteListButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: "edit_list_delete".localized(bundle: Bundle.main)))
        deleteListButton.setImage(UIImage(named: "coreIconDelete"), for: .normal)
        deleteListButton.tintColor = UIColor(colorConfig.primary_button_color!)
    }
    
    @IBAction private func closeAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
    @IBAction private func renameAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate {
            delegate.openEditViewController(field: .title, venue: nil)
            parent.dismissViewController()
        }
    }
    @IBAction private func editSubtitleAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate {
            delegate.openEditViewController(field: .subtitle, venue: nil)
            parent.dismissViewController()
        }
    }
    @IBAction private func editDescriptionAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController, let delegate = delegate {
            delegate.openEditViewController(field: .description, venue: nil)
            parent.dismissViewController()
        }
    }
    @IBAction private func deleteListAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            let deleteVC = DeleteBottomSheetViewController()
            deleteVC.delegate = deleteDelegate
            parent.navigateTo(viewController: deleteVC)
        }
    }
}
