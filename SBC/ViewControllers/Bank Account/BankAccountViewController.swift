//
//  BankAccountViewController.swift
//  SBC
//

import UIKit
import IQKeyboardManagerSwift
import JVFloatLabeledTextField

class BankAccountViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelbottom: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var saveBankButton: UIButton!
    
    @IBOutlet weak var swiftCodeArrowButton: UIButton!
    @IBOutlet weak var bankTypeArrowButton: UIButton!
    
    @IBOutlet weak var textFieldBankType: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorBankType: UILabel!
    @IBOutlet weak var viewBankType: UIView!
    
    @IBOutlet weak var textFieldBank: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorBank: UILabel!
    @IBOutlet weak var viewBank: UIView!
    
    @IBOutlet weak var textFieldFullName: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorFullName: UILabel!
    @IBOutlet weak var viewFullName: UIView!
    
    @IBOutlet weak var textFieldAccountNumber: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorAccountNumber: UILabel!
    @IBOutlet weak var viewAccountNumber: UIView!
    
    @IBOutlet weak var textFieldSwiftCode: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorSwiftCode: UILabel!
    @IBOutlet weak var viewSwiftCode: UIView!
    
    var currentEditingTextfield: UITextField?
    var initialAmount: Float = 00.00
    var dropDown = DropDown()
    var viewModel: BankAccountViewModelProtocol?
    let defaultKeyboardDistanceFromTextField = IQKeyboardManager.shared.keyboardDistanceFromTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.callValidateSchema()
    }
    
    override func setupViewModel() {
        viewModel = BankAccountViewModel()
        viewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUIInitialization()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = defaultKeyboardDistanceFromTextField
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUIInitialization() {
        
        self.labelAmount.text = "S$" + (self.viewModel?.request?.amount ?? 0).getDecimalGroupedAmount()
        
        saveBankButton.isSelected = false
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setTitleColor(.themeLightBlue, for: .disabled)
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = .themeDarkBlueTint2
        
        self.labelbottom.text = K.Review_Withdraw_Info
        // swiftlint:disable line_length
        showScreenTitleWithLeftBarButton(screenTitle: "Withdraw funds", leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleFont: .boldFontWithSize(size: 14), screenTitleColor: colorConfig.navigation_header_color, headerBGColor: .themeDarkBlue)
        
        self.configureTextField()
    }
    
    private func configureTextField() {
        textFieldFullName.becomeFirstResponder()
        for field in [textFieldBankType, textFieldFullName, textFieldBank, textFieldAccountNumber, textFieldSwiftCode] {
            field?.floatingLabel.textColor = .themeDarkBlueTint1
            field?.floatingLabelXPadding = 0
            field?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            field?.delegate = self
            field?.floatingLabel.font = .regularFontWithSize(size: 13)
        }
        textFieldSwiftCode.placeholderColor = .themeDarkBlueTint1
        textFieldAccountNumber.keyboardType = .numberPad
        self.configureDropDown()
    }
    
    func configureDropDown() {
        DropDown.appearance().textColor = .themeDarkBlue
        DropDown.appearance().selectedTextColor = .themeDarkBlue
        DropDown.appearance().textFont = .regularFontWithSize(size: 16)
        DropDown.appearance().selectedTextFont = .boldFontWithSize(size: 16)
        DropDown.appearance().backgroundColor = .themeDarkBlueTint3
        DropDown.appearance().selectionBackgroundColor = .clear
        DropDown.appearance().borderColor = .themeDarkBlue
        DropDown.appearance().cellHeight = 55
        DropDown.appearance().shadowColor = .clear
        DropDown.startListeningToKeyboard()
        
        self.view.layoutIfNeeded()
        dropDown.width = self.viewBank.frame.width
        
        dropDown.cancelAction = { [unowned self] in
            switch self.currentEditingTextfield {
            case textFieldBankType:
                self.updatebankTypeArrowButton(isExpanded: false)
            case textFieldSwiftCode:
                self.updateSwiftCodeArrowButton(isExpanded: false)
            default: break
            }
        }
        
        dropDown.willShowAction = { [unowned self] in
            switch self.currentEditingTextfield {
            case textFieldBankType:
                self.updatebankTypeArrowButton(isExpanded: true)
            case textFieldSwiftCode:
                self.updateSwiftCodeArrowButton(isExpanded: true)
            default: break
            }
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch self.currentEditingTextfield {
            case textFieldBank:
                if self.viewModel?.bankList.contains(where: { (bank) -> Bool in
                    self.textFieldSwiftCode.text = bank.routingCodeValue.first
                    self.updateSwiftCodeArrowButton(isExpanded: false)
                    viewModel?.selectedBank = bank
                    labelErrorBank.isHidden = true
                    return bank.bankName == item
                }) != nil {
                    if let textfield = self.currentEditingTextfield {
                        textfield.text = item
                    }
                }
            case textFieldBankType:
                if (self.viewModel?.accountTypeList.contains(item)) != nil {
                    if let textfield = self.currentEditingTextfield {
                        self.updatebankTypeArrowButton(isExpanded: false)
                        textfield.text = item
                    }
                }
            case textFieldSwiftCode:
                if (self.viewModel?.selectedBank?.routingCodeValue.contains(item)) != nil {
                    if let textfield = self.currentEditingTextfield {
                        textfield.text = item
                        self.updateSwiftCodeArrowButton(isExpanded: false)
                    }
                }
            default: break
            }
            updateConfirmButtonState()
        }
    }
    
    @IBAction private func SaveBank_Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func updateSwiftCodeArrowButton(isExpanded: Bool) {
        DispatchQueue.main.async {
            if isExpanded && self.viewModel?.selectedBank != nil {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    self.swiftCodeArrowButton.transform = CGAffineTransform(rotationAngle: .pi)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    self.swiftCodeArrowButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    func updatebankTypeArrowButton(isExpanded: Bool) {
        DispatchQueue.main.async {
            if isExpanded {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    self.bankTypeArrowButton.transform = CGAffineTransform(rotationAngle: .pi)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    self.bankTypeArrowButton.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    @IBAction private func Confirm_Tapped(_ sender: UIButton) {
        let benificiaryDetailRequest = BeneficiaryDetail(beneficiaryHashID: nil, name: textFieldFullName.text, contactNumber: nil, accountType: nil, email: nil, relationship: nil, address: nil, countryCode: Config.DEFAULT_COUNTRY_CODE_INTITIAL, state: nil, city: nil, postcode: nil)
        let payOutRequest = PayoutDetail(payoutHashID: nil, countryCode: Config.DEFAULT_COUNTRY_CODE_INTITIAL, destinationCurrency: Config.DEFAULT_CURRENCY, bankName: textFieldBank.text, accountType: textFieldBankType.text, accountNumber: textFieldAccountNumber.text, payoutMethod: "LOCAL", routingCodeType1: "SWIFT", routingCodeValue1: self.viewModel?.selectedBank?.routingCodeValue.first)
        
        let request = AddBenificiaryRequest(beneficiaryDetail: benificiaryDetailRequest, payoutDetail: payOutRequest)
        viewModel?.performAddBenificiary(request: request)
    }
    
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        
        switch textField {
        case textFieldBank:
            if textField.getText().count > 0 {
                self.viewModel?.performSearchBank(by: textField.text)
            } else {
                dropDown.hide()
            }
        default: break
        }
    }
    
    func showDropDownForBank() {
        DispatchQueue.main.async {
            self.dropDown.anchorView = self.viewBank
            self.dropDown.dataSource = self.viewModel?.getBankNameList() ?? []
            self.labelErrorBank.isHidden = true
            self.labelErrorBank.text = localizedStringForKey(key: "withdraw.error.invalid.bank")
            if self.viewModel?.getBankNameList().isEmpty ?? true {
                self.labelErrorBank.isHidden = false
                self.labelErrorBank.text = localizedStringForKey(key: "withdraw.bank.search.no.result.found")
            }
            self.dropDown.show()
        }
    }
}

// MARK: - BankAccountPassingDelegate {
extension BankAccountViewController: BankAccountPassingDelegate {
    func addBeneficiarySucces(response: AddBenificiaryResponse) {
        viewModel?.getExchangeRate()
    }
    
    func failure(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func transfermoneySucces(response: TransferMoneyResponse) {
        navigateToSuccessTransaction()
    }
    
    func transfermoneyfailure(message: String) {
        navigateToFailureTrasanction()
    }
    
    func exchangeRateSucces(response: ExchangeRateResponse) {
        DispatchQueue.main.async { [self] in
            let amount = "\(self.viewModel?.request?.amount ?? 0)"
            let payOutRequest = PayoutRequest(audit_id: response.auditID, payout_id: viewModel?.addBenificiaryResponse?.data.payout.id ?? "", source_amount: amount)
            let beneRequest = BeneficiaryRequest(id: viewModel?.addBenificiaryResponse?.data.id ?? "")
            let request = TransferMoneyRequest(beneficiary: beneRequest, payout: payOutRequest)
            viewModel?.transferMoney(request: request)
        }
    }
    
    func showBankNameListResponse(response: SearchBankResponse) {
        if let textfield = self.currentEditingTextfield, textfield == self.textFieldBank {
            showDropDownForBank()
        }
    }
    
    func showBankNameListFailure(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func addBeneficiarySucces(response: TopUpCardFundResponse) {
        //Todo:
    }
    
    func addBeneficiaryFailure(message: String) {
        //Todo:
    }
}

// MARK: TextField Delegate
extension BankAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = defaultKeyboardDistanceFromTextField
        self.currentEditingTextfield = textField
        self.dropDown.hide()
        if textField == self.textFieldBankType {
            self.view.endEditing(true)
            if !NetworkReachabilityStatus.isConnected() {
                CommonAlertHandler.showErrorResponseAlert(for: localizedStringForKey(key: "alert.offline.desc"))
                return false
            }
            if viewModel?.accountTypeList.isEmpty ?? true {
                CommonAlertHandler.showErrorResponseAlert(for: localizedStringForKey(key: "error_popup_message"))
                return false
            }
            self.dropDown.anchorView = self.viewBankType
            self.dropDown.dataSource = self.viewModel?.accountTypeList ?? []
            self.dropDown.show()
            return false
        } else if textField == self.textFieldFullName {
            labelErrorFullName.isHidden = true
            viewFullName.backgroundColor = .themeNeonBlue
            viewBank.backgroundColor = .themeDarkBlue
            viewAccountNumber.backgroundColor = .themeDarkBlue
        } else if textField == self.textFieldBank {
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 150
            self.viewModel?.selectedBank = nil
            labelErrorBank.isHidden = true
            textField.text = ""
            textFieldSwiftCode.text = ""
            viewFullName.backgroundColor = .themeDarkBlue
            viewBank.backgroundColor = .themeNeonBlue
            viewAccountNumber.backgroundColor = .themeDarkBlue
            self.dropDown.anchorView = self.viewBank
            self.dropDown.dataSource = []
            self.dropDown.show()
        } else if textField == self.textFieldAccountNumber {
            labelErrorAccountNumber.isHidden = true
            viewFullName.backgroundColor = .themeDarkBlue
            viewBank.backgroundColor = .themeDarkBlue
            viewAccountNumber.backgroundColor = .themeNeonBlue
        } else if textField == self.textFieldSwiftCode {
            self.view.endEditing(true)
            self.dropDown.anchorView = self.viewSwiftCode
            self.dropDown.dataSource = self.viewModel?.selectedBank?.routingCodeValue ?? []
            self.dropDown.show()
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let textString = textField.text ?? ""
        if textField == self.textFieldFullName {
            if  !(viewModel?.beneDetailValidator.isValidBeneFullName(value: textString) ?? false) {
                labelErrorFullName.isHidden = false
                confirmButton.isEnabled = false
                confirmButton.backgroundColor = .themeDarkBlueTint2
            }
            viewFullName.backgroundColor = .themeDarkBlue
            
        } else if textField == self.textFieldBank {
            if !(viewModel?.beneDetailValidator.isValidBankName(value: textString) ?? false) || textString.isEmpty {
                labelErrorBank.isHidden = false
                labelErrorBank.text = localizedStringForKey(key: "withdraw.error.invalid.bank")
                confirmButton.isEnabled = false
                confirmButton.backgroundColor = .themeDarkBlueTint2
                textFieldSwiftCode.placeholderColor = .themeDarkBlueTint1
            } else {
                textFieldSwiftCode.placeholderColor = .themeDarkBlue
            }
            viewBank.backgroundColor = .themeDarkBlue
            
        } else if textField == self.textFieldAccountNumber {
            if !(viewModel?.beneDetailValidator.isValidAccountNumber(value: textString) ?? false) {
                labelErrorAccountNumber.isHidden = false
                confirmButton.isEnabled = false
                confirmButton.backgroundColor = .themeDarkBlueTint2
            }
            viewAccountNumber.backgroundColor = .themeDarkBlue
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textString = textField.text ?? ""
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            self.updateConfirmButtonState()
        }
        
        return true
    }
    
    private func updateConfirmButtonState() {
        if self.isAllBeneDetailsValid() {
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = .themeDarkBlue
        } else {
            self.confirmButton.isEnabled = false
            self.confirmButton.backgroundColor = .themeDarkBlueTint2
        }
    }
    
    private func isAllBeneDetailsValid() -> Bool {
        guard let viewModel = viewModel else {
            return false
        }
        return viewModel.beneDetailValidator.isValidAccountNumber(value: textFieldAccountNumber.getText()) &&
            viewModel.beneDetailValidator.isValidBankName(value: textFieldBank.getText()) &&
            viewModel.beneDetailValidator.isValidBeneFullName(value: textFieldFullName.getText()) &&
            !textFieldBankType.getText().isEmpty && !textFieldSwiftCode.getText().isEmpty
    }
    
}
extension BankAccountViewController {
    func navigateToSuccessTransaction () {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.SuccessWithdraw, title: localizedStringForKey(key: "withdraw.success.message"), desc: "", contact: "",
                                       btnTitle: localizedStringForKey(key: "button.title.back_to_wallet"),
                                       backgroundColor: ColorHex.ThemeNeonBlue)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToFailureTrasanction() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.Oops, title: localizedStringForKey(key: "transaction.failure.card"),
                                       desc: "", contact: "", btnTitle: localizedStringForKey(key: "button.title.withdraw"),
                                       backgroundColor: ColorHex.ThemeRed)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
