//
//  CardPaymentViewController.swift
//  SBC
//

import UIKit
import JVFloatLabeledTextField
import IQKeyboardManagerSwift

class CardPaymentViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelMethod: UILabel!
    @IBOutlet weak var labelSavedCard: UILabel!
    @IBOutlet weak var labelErrorExpiryDate: UILabel!
    @IBOutlet weak var labelErrorCardNumber: UILabel!
    @IBOutlet weak var labelErrorCVV: UILabel!
    @IBOutlet weak var labelConfirmDesc: UILabel!
    @IBOutlet weak var labelErrorCardHolderName: UILabel!
    @IBOutlet weak var labelTooltipCVV: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var textFieldExpiryDate: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldCardNumber: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldCVV: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldCardHolderName: JVFloatLabeledTextField!
    
    @IBOutlet var textFieldBottomView: [UIView]!
    
    @IBOutlet weak var tooltipContainerView: UIView!
    @IBOutlet weak var bottomStackViewBottomConstraint: NSLayoutConstraint!
    
    let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
    let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
    
    var viewModel: CardPaymentViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUIInitialization()
        IQKeyboardManager.shared.enableAutoToolbar = true
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        removeKeyboardNotification()
    }
    
    override func setupViewModel() {
        viewModel = CardPaymentViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UI Configuration
    func configureUIInitialization() {
        configureHeader()
        let amount = self.viewModel?.request?.amount
        self.labelAmount.text = String.formatAmountToCurrencyString(amount: amount)
        textFieldCardHolderName.becomeFirstResponder()
        saveCardButton.isSelected = false
        cameraButton.isHidden = true
        tooltipContainerView.isHidden = true
        labelTooltipCVV.text = localizedStringForKey(key: "top.up.cvv.tooltip.message")
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitleColor(.themeLightBlue, for: .disabled)
        submitButton.isEnabled = false
        submitButton.backgroundColor = .themeDarkBlueTint2
        labelConfirmDesc.font = .regularFontWithSize(size: 13)
        labelConfirmDesc.textColor = .themeDarkBlue
        configureTextField()
    }
    
    private func configureHeader() {
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(key: "top.up.screen.title"),
                                         leftButtonImage: ImageConstants.IMG_BACK_WHITE,
                                         screenTitleFont: .boldFontWithSize(size: 14),
                                         screenTitleColor: colorConfig.navigation_header_color, headerBGColor: .themeDarkBlue)
    }
    
    private func configureTextField() {
        
        for field in [textFieldCardNumber, textFieldExpiryDate, textFieldCVV, textFieldCardHolderName] {
            field?.floatingLabel.textColor = .themeDarkBlueTint1
            field?.keyboardType = .numberPad
            field?.floatingLabelXPadding = 0
            field?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            field?.delegate = self
            field?.floatingLabel.font = .regularFontWithSize(size: 13)
        }
        textFieldCardHolderName.keyboardType = .default
    }
    
    // MARK: - Keyboard Handling
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHide, object: nil)
    }
    
    @objc  func keyboardWillShow(_ notification: Notification?) {
        
        //  Getting UIKeyboardSize.
        if let info = notification?.userInfo, let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            labelConfirmDesc.isHidden = true
            bottomStackViewBottomConstraint.constant = kbFrame.size.height + 20
        }
    }
    
    @objc  func keyboardWillHide(_ notification: Notification?) {
        labelConfirmDesc.isHidden = false
        bottomStackViewBottomConstraint.constant = 30
    }
    
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case textFieldCardNumber:
            textField.reformatAsCardNumber()
        case textFieldExpiryDate!:
            textField.reformatAsExpiration()
        case textFieldCVV:
            textField.reformatAsCVV()
        default: break
        }
    }
    
    private func updateConfirmButtonState(to active: Bool) {
        submitButton.isEnabled = active
        submitButton.backgroundColor = getSubmitButtonColor(active: active)
        labelConfirmDesc.isHidden = !active
    }
    
    private func getSubmitButtonColor(active: Bool) -> UIColor {
        if active {
            return .themeDarkBlue
        } else {
            return .themeDarkBlueTint2
        }
    }
    
    @IBAction private func SaveCard_Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction private func Camera_Tapped(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = .camera
            cameraController.allowsEditing = false
            cameraController.mediaTypes = [kCIAttributeTypeImage]
            
            self.present(cameraController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction private func Info_Tapped(_ sender: UIButton) {
        tooltipContainerView.isHidden = !tooltipContainerView.isHidden
    }
    
    @IBAction private func Confirm_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let base64CardNumber = textFieldCardNumber.getText().removingWhitespaces().toBase64() ?? ""
        let base64ExpiryDate = textFieldExpiryDate.getText().replacingOccurrences(of: "/", with: "").toBase64() ?? ""
        let base64CVV = textFieldCVV.getText().toBase64() ?? ""
        let amount = "\(self.viewModel?.request?.amount ?? 0)"
        let request = TopUpCardRequest(amount: amount, fundingInstrumentId: "",
                                       fundingInstrumentHolderName: textFieldCardHolderName.getText(),
                                       fundingInstrumentSecurityNumber: base64CVV,
                                       fundingInstrumentNumber: base64CardNumber,
                                       fundingInstrumentExpiry: base64ExpiryDate,
                                       save: saveCardButton.isSelected)
        viewModel?.performAddCard(request: request)
        
    }
    
}

extension CardPaymentViewController: CardPaymentPassingDelegate {
    func addCardSucces(response: TopUpCardFundResponse) {
        navigateToStripeVC(response: response)
    }
    
    func addCardFailure(message: String) {
        navigateToOOPS()
    }
}

extension CardPaymentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    }
}

// MARK: TextField Delegate
extension CardPaymentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.textFieldCardNumber {
            labelErrorCardNumber.isHidden = true
        } else if textField == self.textFieldExpiryDate {
            textField.placeholder = localizedStringForKey(key: "add.card.expiry.date.mmyy.label")
            textFieldExpiryDate.floatingLabel.text = localizedStringForKey(key: "add.card.expiry.date.label")
            labelErrorExpiryDate.isHidden = true
        } else if textField == self.textFieldCVV {
            labelErrorCVV.isHidden = true
        } else if textField == self.textFieldCardHolderName {
            labelErrorCardHolderName.isHidden = true
        }
        
        for bgView in textFieldBottomView {
            bgView.backgroundColor = .themeDarkBlue
            if textField.tag == bgView.tag {
                bgView.backgroundColor = .themeNeonBlue
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.textFieldCardNumber {
            if !CommonValidation.isValidCardNumber(textField.text ?? "" ) || textFieldCardNumber.text == "" {
                labelErrorCardNumber.isHidden = false
                updateConfirmButtonState(to: false)
            } else {
                labelErrorCardNumber.isHidden = true
            }
            
        } else if textField == self.textFieldExpiryDate {
            textField.placeholder = textFieldExpiryDate.floatingLabel.text
            if !CommonValidation.isValidExpiryDate(textField.text ?? "") || textFieldExpiryDate.text == "" {
                labelErrorExpiryDate.isHidden = false
                updateConfirmButtonState(to: false)
            }
            
        } else if textField == self.textFieldCVV {
            if textFieldCVV.getText().count != 3 {
                labelErrorCVV.isHidden = false
                updateConfirmButtonState(to: false)
            }
        } else if textField == self.textFieldCardHolderName {
            if !CommonValidation.isValidFullName(textField.getText()) || textFieldCardHolderName.text == "" {
                labelErrorCardHolderName.isHidden = false
                updateConfirmButtonState(to: false)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            if CommonValidation.isValidCardNumber(self.textFieldCardNumber.getText()) &&
                CommonValidation.isValidExpiryDate(self.textFieldExpiryDate.getText()) &&
                CommonValidation.isValidFullName(self.textFieldCardHolderName.getText()) &&
                self.textFieldCVV.getText().length() == 3 {
                if textField != self.textFieldCardHolderName {
                    self.view.endEditing(true)
                }
                self.updateConfirmButtonState(to: true)
            } else {
                self.updateConfirmButtonState(to: false)
            }
        }
        
        let textFieldString = textField.text ?? ""
        if textField == self.textFieldExpiryDate {
            if textFieldString.count == 1 && string == "" {
                return true
            }
            if textFieldString.getCharOfIndex(index: range.location) == "/" && string == "" {
                let text = textField.getText().prefix(2)
                textField.text = String(text)
                return false
            }
            if  textFieldString.appending(string).count <= 5 {
                return true
            } else {
                return false
            }
        }
        
        if textField == self.textFieldCardNumber {
            if CommonValidation.isValidInputForCardNumber(textFieldString.appending(string)) {
                return true
            } else {
                return false
            }
        }
        if textField == self.textFieldCardHolderName {
            if CommonValidation.isValidFullName(textFieldString.appending(string)) {
                return true
            } else {
                return false
            }
        }
        return true
    }
}

// MARK: Navigation
extension CardPaymentViewController {
    func navigateToStripeVC(response: TopUpCardFundResponse? = nil) {
        let vc = StripeUIWebviewViewController.instantiateFromStoryboard(storyboardName: StoryboardName.StripeWebView, storyboardId: StoryboardId.StripeUIWebviewViewController)
        vc.viewModel?.topUpCardFundResponse = response
        vc.viewModel?.redirectURL = response?.returnUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToOOPS() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.Oops, title: localizedStringForKey(key: "transaction.failure.card"),
                                       desc: "", contact: "", btnTitle: localizedStringForKey(key: "button.title.topUP"),
                                       backgroundColor: ColorHex.ThemeRed)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
