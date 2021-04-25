import UIKit
import JVFloatLabeledTextField

protocol CreatePlaylistProtocol: class {
    func updateField(withText: String, forField: PlaylistField)
}

class EditPlaylistFieldViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var editTextField: JVFloatLabeledTextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    //Create playlist
    @IBOutlet weak var createPlaylistBottomView: UIView!
    @IBOutlet weak var addSubtitleView: UIStackView!
    @IBOutlet weak var addSubtitleButton: UIButton!
    @IBOutlet weak var addDescriptionView: UIStackView!
    @IBOutlet weak var addDescriptionButton: UIButton!
    @IBOutlet weak var createSubtitleView: UIView!
    @IBOutlet weak var listSubtitleLabel: UILabel!
    @IBOutlet weak var newSubtitleLabel: UILabel!
    
    @IBOutlet weak var createDescriptionView: UIView!
    @IBOutlet weak var listDescriptionLabel: UILabel!
    @IBOutlet weak var createListButton: UIButton!
    @IBOutlet weak var newDescriptionLabel: UILabel!
    private var createListSubtitle = ""
    private var createListDescription = ""
    
    var viewModel: EditPlaylistFieldViewModel?
    weak var delegate: PlaylistDetailsDataDelegate?
    weak var createDelegate: CreatePlaylistProtocol?
    final let kBottomConstraint: CGFloat = 36.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton(screenTitle: viewModel?.field.screenTitle, screenTitleColor: colorConfig.primary_text_color )
        IBViewTop.setLeftButtonColor(color: UIColor(colorConfig.primary_text_color!)!)
        setupView()
        fillField()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.isHidden = true
    }
    
    fileprivate func setupView() {
        titleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: viewModel?.field.title, fontSize: 20, textColor: UIColor(colorConfig.primary_text_color!)))
        subtitleLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: viewModel?.field.subtitle, fontSize: 12, textColor: UIColor(colorConfig.edit_field_secondary_text_color!)))
        if viewModel?.field == .description || viewModel?.field == .venueCaption {
            editTextField.isHidden = true
            separatorView.isHidden = true
            editTextView.isHidden = false
            editTextView.becomeFirstResponder()
        } else {
            editTextField.isHidden = false
            separatorView.isHidden = false
            addClearButton()
            editTextView.isHidden = true
            editTextField.becomeFirstResponder()
            
        }
        if viewModel?.field == .newList {
            createPlaylistBottomView.isHidden = false
            saveButton.isHidden = true
            createSubtitleView.isHidden = true
            createDescriptionView.isHidden = true
            addSubtitleButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "create_list_addSubtitle_button"), fontSize: 16, textColor: .white))
            addDescriptionButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "create_list_addDescription_button"), fontSize: 16, textColor: .white))
            
            createListButton.setButtonConfig(btnConfig: ButtonConfig.getBackgroundButtonConfig(titleText: localizedStringForKey(key: "create_list_create_button"), fontSize: 18, textColor: UIColor.themeDarkBlue, backgroundColor: UIColor.themeNeonBlue, cornerRadius: 8))
            createListButton.setTitleColor(UIColor.themeDarkBlue.withAlphaComponent(0.5), for: .disabled)
            createListButton.isEnabled = false
        } else {
            createPlaylistBottomView.isHidden = true
            saveButton.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: localizedStringForKey(key: "edit_button_save"), fontSize: 16, cornerRadius: 8))
            saveButton.setTitleColor(UIColor.themeDarkBlueTint1, for: .disabled)
            saveButton.setTitleColor(UIColor.white, for: .normal)
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.themeDarkBlueTint2
        }
        errorLabel.isHidden = true
    }
    
    private func addClearButton() {
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        clearButton.setImage(UIImage(named: "coreIconCross"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        editTextField.rightView = clearButton
        editTextField.rightViewMode = .whileEditing
    }
    
    @objc private func clearText() {
        editTextField.text = ""
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.themeDarkBlueTint2
        createListButton.isEnabled = false
        createListButton.backgroundColor = UIColor.themeNeonBlue2
    }
    
    private func fillField() {
        if let viewModel = viewModel {
            if viewModel.field == .title || viewModel.field == .subtitle {
                editTextField.text = viewModel.currentFieldValue()
            } else {
                editTextView.text = viewModel.currentFieldValue()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonBottomConstraint.constant = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        buttonBottomConstraint.constant = kBottomConstraint
        
    }
    // MARK: Actions
    @IBAction func saveAction(_ sender: Any) {
        if let viewModel = viewModel, let textToValidate = (viewModel.field == .title || viewModel.field == .subtitle) ? editTextField.text : editTextView.text {
            let validationState = viewModel.validateField(textToValidate: textToValidate)
            switch validationState {
            case .valid:
                errorLabel.isHidden = true
                viewModel.performRequest(withTitle: textToValidate, subtitle: nil, description: nil)
                
            case .inValid(let error):
                errorLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: error, fontSize: 13, textColor: UIColor(colorConfig.primary_button_negative_color!), numberOfLines: 0))
                errorLabel.isHidden = false
                saveButton.isEnabled = false
                saveButton.backgroundColor = UIColor.themeDarkBlueTint2
            }
        }
    }
    
    @IBAction func createListAction(_ sender: Any) {
        if let viewModel = viewModel, let textToValidate = editTextField.text {
            let validationState = viewModel.validateField(textToValidate: textToValidate)
            switch validationState {
            case .valid:
                errorLabel.isHidden = true
                viewModel.performRequest(withTitle: textToValidate, subtitle: createListSubtitle, description: createListDescription)
            case .inValid(let error):
                errorLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: error, fontSize: 13, textColor: UIColor(colorConfig.primary_button_negative_color!), numberOfLines: 0))
                errorLabel.isHidden = false
                saveButton.isEnabled = false
                createListButton.isEnabled = false
            }
        }
    }
    
    @IBAction func openAddsubtitle(_ sender: Any) {
        let editViewController = EditPlaylistFieldViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.EditPlaylistFieldViewController)
        let editViewModel = EditPlaylistFieldViewModel(withField: .subtitle, currentValue: createListSubtitle)
        editViewModel.createDelegate = editViewController
        editViewController.viewModel = editViewModel
        editViewController.createDelegate = self
        navigationController?.pushViewController(editViewController, animated: true)
    }
    @IBAction func openAddDescription(_ sender: Any) {
        let editViewController = EditPlaylistFieldViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.EditPlaylistFieldViewController)
        let editViewModel = EditPlaylistFieldViewModel(withField: .description, currentValue: createListDescription)
        editViewModel.createDelegate = editViewController
        editViewController.viewModel = editViewModel
        editViewController.createDelegate = self
        navigationController?.pushViewController(editViewController, animated: true)
    }
}

extension EditPlaylistFieldViewController: EditPlaylistViewModelProtocol {
    func updateLoadingStatus(isLoading: Bool) {
        if isLoading {
            CommonUtil.sharedInstance.showLoader()
        } else {
            CommonUtil.sharedInstance.removeLoader()
        }
    }
    func goBack(withData: Playlist?) {
        if let delegate = delegate, let newData = withData {
            delegate.didReceiveData(playlistResponse: newData)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func goToNewPlaylist(withData: Playlist?) {
        self.navigationController?.popViewController(animated: true)
        if let delegate = delegate, let newData = withData {
            delegate.didReceiveData(playlistResponse: newData)
        }
    }
    
    func failureWithError(error: APIError) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Try again"), negativeButtonText: "Cancel")
        
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: false)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction = { [weak self] in
            self?.viewModel?.tryAgain()
        }
        view.addSubview(actionPopupView)
    }
}

extension EditPlaylistFieldViewController: CreatePlaylistViewModelProtocol {
    func goBack(withText: String, forField: PlaylistField) {
        createDelegate?.updateField(withText: withText, forField: forField)
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditPlaylistFieldViewController: CreatePlaylistProtocol {
    func updateField(withText: String, forField: PlaylistField) {
        if forField == .subtitle {
            createSubtitleView.isHidden = false
            addSubtitleView.isHidden = true
            createListSubtitle = withText
            listSubtitleLabel.setLabelConfig(lblConfig: LabelConfig(text: localizedStringForKey(key: "create_list_subtitle_button"), font: UIFont.mediumFontWithSize(size: 13), textColor: UIColor.themeDarkBlueTint2))
            newSubtitleLabel.setLabelConfig(lblConfig: LabelConfig(text: createListSubtitle, font: UIFont.regularFontWithSize(size: 16), textColor: .white))
        } else if forField == .description {
            createDescriptionView.isHidden = false
            addDescriptionView.isHidden = true
            createListDescription = withText
            listDescriptionLabel.setLabelConfig(lblConfig: LabelConfig(text: localizedStringForKey(key: "create_list_description_button"), font: UIFont.mediumFontWithSize(size: 13), textColor: UIColor.themeDarkBlueTint2))
            newDescriptionLabel.setLabelConfig(lblConfig: LabelConfig(text: createListDescription, font: UIFont.regularFontWithSize(size: 16), textColor: .white, numberOfLines: 0))
        }
    }
}

// MARK: TextField Delegate
extension EditPlaylistFieldViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let field = viewModel?.field
            else { return true }
        
        let text = textFieldText as NSString
        let finalString = text.replacingCharacters(in: range, with: string)
        
        if finalString.count > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.themeDarkBlue
            createListButton.isEnabled = true
            createListButton.backgroundColor = UIColor.themeNeonBlue
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.themeDarkBlueTint2
            createListButton.isEnabled = false
            createListButton.backgroundColor = UIColor.themeNeonBlue2
        }
        
        return finalString.count <= field.characterLimit
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text, let field = viewModel?.field
            else { return true }
        
        let addedText = textViewText as NSString
        let finalString = addedText.replacingCharacters(in: range, with: text)
        
        if finalString.count > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(colorConfig.primary_button_color!)
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.themeDarkBlueTint2
        }
        
        return finalString.count <= field.characterLimit
    }
}
