//
//  WalletRegistartionViewController.swift
//  SBC

import UIKit

class AcceptMobileNumberViewController: BaseViewController, UITextFieldDelegate, AcceptMobileNumberViewModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgView: UIImageView!
    var txtMobile: CustomTextfieldView!
    var btnNext: UIButton!
    var btnCountryCode: UIButton!
    var btnShowPassword: UIButton!
    var viewModel = AcceptMobileNumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func leftButtonAction(button: UIButton) {
        self.view.endEditing(true)
        if viewModel.acceptMobileNumberModel?.endPoint == MobileOTPType.registerWallet {
            showActionPopup(parentView: self.view)
            return
        }
        super.leftButtonAction(button: button)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if viewModel.acceptMobileNumberModel?.title == K.EMPTY {
            return .lightContent
        }
        return super.preferredStatusBarStyle
    }
    
    private func showActionPopup(parentView: UIView) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "ARE_YOU_SURE"),
                                              descText: localizedStringForKey(key: "WALLET_REGISTRATION_PROGRESS_DESC"),
                                              positiveButtonText: localizedStringForKey(key: "YES_ACTION"),
                                              negativeButtonText: localizedStringForKey(key: "STAY_CONTINUE"))
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: false)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction  = {
            var index = 0
            if let tabBarVC = self.tabBarController as? TabbarController {
                index = tabBarVC.previousSelectedTabBarIndex
            }
            RootViewControllerRouter.setTabbarAsRootVC(animated: false, initialVCIndex: index)
        }
        parentView.addSubview(actionPopupView)
    }
    
    // MARK: UI setup
    private func setUpUI() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.getCells()
        registerNib()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        let tittle = viewModel.acceptMobileNumberModel?.title
        if tittle == K.EMPTY {
            self.navigationController?.isNavigationBarHidden = true
            showScreenTitleWithLeftBarButton(screenTitle: "Update mobile number", leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleFont: .mediumFontWithSize(size: 15), screenTitleColor: "", headerBGColor: .themeDarkBlue)
            self.tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
            self.imgView.image = UIImage(named: "")
        } else {
            self.navigationController?.isNavigationBarHidden = true
            showScreenTitleWithLeftBarButton()
            self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    private func registerNib() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "mobileCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TittleCell")
    }
    
    func FailureWithError(message: String) {
        CommonUtil.sharedInstance.removeLoader()
        txtMobile.setState(state: CustomTextfieldView.FieldState.error)
        txtMobile.configureError(error: message)
        tableView.reloadData()
    }
    
    func Success() {
        CommonUtil.sharedInstance.removeLoader()
        navigateToOTPHandlerVC()
    }
    
    // MARK: Button Action
    @IBAction func didTappedNextButtonAction(_ sender: UIButton) {
        btnNext = sender
        self.view.endEditing(true)
        if viewModel.arrayOfCells.contains(.cellMobileNo) {
            
            let mobileNo = txtMobile.getText()
            
            viewModel.mobileNumber = mobileNo?.replacingOccurrences(of: " ", with: "") ?? ""
        }
        let validationState = validate()
        if validationState == .valid {
            
            CommonUtil.userMobile = viewModel.mobileNumber
            CommonUtil.countryCode = Config.DEFAULT_COUNTRY_CODE
            viewModel.callGenerateMobileOTPAPI(request: OTPGenerationRequest(email: nil, mobile: viewModel.mobileNumber, countryCode: Config.DEFAULT_COUNTRY_CODE))
        }
    }
    
    private func navigateToOTPHandlerVC() {
        let vc = OTPHandlingViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Verification, storyboardId: StoryboardId.OTPHandlingViewController)
        
        let attrStr = String(format: K.Verify_mobile_Desc, Config.DEFAULT_COUNTRY_CODE, viewModel.mobileNumber )
        
        var mobileOTPType: MobileOTPType? = .registerWallet
        if viewModel.acceptMobileNumberModel?.title == localizedStringForKey(key: "forgot.pin.title") {
            mobileOTPType = .forgotPin
            let model = OTPModel(title: K.Verification_Mobile_Tittle, desc: attrStr, contactInfo: viewModel.mobileNumber, resendTitle: K.Verify_mobile_Resend_Title, mobileOTPType: mobileOTPType)
            vc.viewModel?.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        } else if viewModel.acceptMobileNumberModel?.title == K.EMPTY {
            mobileOTPType = .updateMobileNo
            var formattedMobileNumber: String? {
                if viewModel.mobileNumber.isEmpty {
                    return nil
                }
                return "+\(CommonUtil.countryCode) \(viewModel.mobileNumber.grouping(every: 4, with: " "))"
            }
            let attstr = String(format: K.Verify_UpdateMobile_desc, formattedMobileNumber ?? "")

            let model = OTPModel(title: K.EMPTY, desc: attstr, contactInfo: viewModel.mobileNumber, resendTitle: K.Verify_mobile_Resend_Title, mobileOTPType: mobileOTPType)
            vc.viewModel?.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let model = OTPModel(title: K.Verification_Mobile_Tittle, desc: attrStr, contactInfo: viewModel.mobileNumber, resendTitle: K.Verify_mobile_Resend_Title, mobileOTPType: mobileOTPType)
            vc.viewModel?.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUpClearTextBtn(txtMobileField: CustomTextfieldView) {
        btnShowPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: txtMobileField.textfield.frame.size.height))
        btnShowPassword.contentMode = .center
        btnShowPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowPassword.setImage(image: UIImage(named: ImageConstants.clear_Btn), tintColor: .themeDarkBlue, forUIControlState: .normal)
        btnShowPassword.addTarget(self, action: #selector(self.btnShowPasswordClicked), for: .touchUpInside)
        txtMobileField.configureRightPanel(rightButton: btnShowPassword)
    }
    
    @objc func btnShowPasswordClicked(_ sender: UIButton) {
        txtMobile.textfield.text = ""
        viewModel.mobileNumber = txtMobile.textfield.text ?? ""
        let cell = tableView.cellForRow(at: IndexPath.init(row: AcceptMobileNumberCells.cellMobileNo.rawValue, section: 0)) as? TextfieldTableViewCell
        cell?.textfield.placeholder.isHidden = true
        tableView.reloadData()
    }
        
    private func getMobileTextCell() -> TextfieldTableViewCell? {
        let indexPath = IndexPath(row: AcceptMobileNumberCells.cellMobileNo.rawValue, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextfieldTableViewCell
    }
    
    // MARK: TextField Delegate
    
    @IBAction func mobileFieldEditingDidBegin(_ sender: Any) {
        if viewModel.acceptMobileNumberModel?.title == K.EMPTY {
            self.setUpClearTextBtn(txtMobileField: (getMobileTextCell()?.textfield)!)
        }
        self.setUpCountryCodePanell(txtMobileField: (getMobileTextCell()?.textfield)!)
        _ = self.applyStateOnTextfield(textfield: txtMobile, state: .valid, tableView: tableView)
        if txtMobile.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtMobile.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func mobileFieldEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField

        textfield?.text = textfield?.text?.grouping(every: 4, with: " ")
        let text = textfield?.text?.replacingOccurrences(of: " ", with: "")
        viewModel.mobileNumber = text ?? ""
        let validationState =  validateMobileNumber(isWantToUpdateUI: false)
        if validationState == .valid {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
        tableView.reloadRows(at: [IndexPath(row: AcceptMobileNumberCells.cellProceddBtn.rawValue, section: 0)], with: .none)
        
    }
    
    @IBAction func mobileFieldEditingDidEnd(_ sender: Any) {
        if txtMobile.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtMobile.setState(state: CustomTextfieldView.FieldState.normal)
        }
        let validationState =  validateMobileNumber(isWantToUpdateUI: txtMobile.getText()?.count ?? 0 > 0)
        
        if validationState == .valid {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
        tableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if string == " " {
            return false
        }
        let text = "\(textField.text ?? "")\(string)"
        if txtMobile != nil {
            if textField == txtMobile.textfield {
                let mobileNoLengthLimit = Config.DEFAULT_MOBILE_LIMIT
                if text.replacingOccurrences(of: " ", with: "").count <= mobileNoLengthLimit {
                    return text.isValidPhoneInputForUpdate
                } else if text.length() > mobileNoLengthLimit {
                    return false
                }
            }
        }
        
        return true
    }
    
    /// set up the Countoury code panel
    func setUpCountryCodePanell(txtMobileField: CustomTextfieldView) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: txtMobileField.textfield.frame.size.height))
        btnCountryCode = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnCountryCode.setTitle("+\(Config.DEFAULT_COUNTRY_CODE)  ", for: .normal)
        btnCountryCode.setTitleColor(UIColor.themeLightBlue, for: .normal)
        AppManager.appStyle.apply(textStyle: .countryCodeButton, to: btnCountryCode)
        view.addSubview(btnCountryCode)
        txtMobile.configureLeftPanell(leftButton: view)
    }
    
    /// set up the Countoury code panel
    func setUpCountryCodePanel(txtMobileField: CustomTextfieldView) {
        btnCountryCode = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: txtMobileField.textfield.frame.size.height))
        btnCountryCode.setTitle("+\(Config.DEFAULT_COUNTRY_CODE)  ", for: .normal)
        btnCountryCode.setTitleColor(UIColor.themeLightBlue, for: .normal)
        AppManager.appStyle.apply(textStyle: .countryCodeButton, to: btnCountryCode)
        txtMobileField.configureLeftPanel(leftButton: btnCountryCode)
    }
    
    func removeCountryCodePanel(txtMobileField: CustomTextfieldView) {
        let indexPath = IndexPath(row: AcceptMobileNumberCells.cellMobileNo.rawValue, section: 0)
        return tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: Validations
    
    func addActionsForMobileField(txtMobileNumber: CustomTextfieldView) {
        txtMobileNumber.textfield.delegate = self
        txtMobileNumber.textfield.addTarget(self, action: #selector(self.mobileFieldEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        txtMobileNumber.textfield.addTarget(self, action: #selector(self.mobileFieldEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtMobileNumber.textfield.addTarget(self, action: #selector(self.mobileFieldEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
    }
    private  func validate() -> ValidationState {
        
        let mobilevalidationState = validateMobileNumber(isWantToUpdateUI: true)
        switch mobilevalidationState {
        case (.valid):
            return .valid
        default:
            break
        }
        return .inValid("")
    }
    
    private func validateMobileNumber(isWantToUpdateUI: Bool) -> ValidationState {
        let validationState = viewModel.validateMobileNumber(isWantToUpdateUI: isWantToUpdateUI)
        if !isWantToUpdateUI {
            return validationState
        }
        if viewModel.arrayOfCells.contains(.cellMobileNo) {
            guard let textfield = txtMobile else {
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
    }
    
    private func applyStateOnTextfield(textfield: CustomTextfieldView, state: ValidationState) -> ValidationState {
        switch state {
        case .valid:
            let state = textfield.textfield.isFirstResponder ? CustomTextfieldView.FieldState.editing :  CustomTextfieldView.FieldState.normal
            textfield.setState(state: state)
        case .inValid(let error):
            textfield.setState(state: CustomTextfieldView.FieldState.error)
            textfield.configureError(error: error)
        }
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        return state
    }
    
}
