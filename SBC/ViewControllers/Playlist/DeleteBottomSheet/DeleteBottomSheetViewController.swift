import UIKit

class DeleteBottomSheetViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    weak var delegate: DeleteFieldProtocol?
    var venue: Venue?
    var deleteField: DeleteField = .playlist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        deleteButton.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: deleteField.deleteButtonTitle, fontSize: 16, textColor: UIColor.white, backgroundColor: UIColor(colorConfig.primary_button_negative_color!), cornerRadius: 8))
        cancelButton.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: "delete_list_cancel_button".localized(bundle: Bundle.main), fontSize: 16, textColor: UIColor(colorConfig.primary_button_color!)!, backgroundColor: UIColor.white, cornerRadius: 8))
        
        titleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: deleteField.sheetTitle, fontSize: 16, textAlignment: .center))
        subtitleLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: deleteField.sheetSubtitle))
    }
    
    @IBAction func closeAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
            delegate?.delete(field: deleteField, venue: venue)
        }
    }
}
