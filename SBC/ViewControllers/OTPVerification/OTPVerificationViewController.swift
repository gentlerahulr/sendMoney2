import UIKit

class OTPHandlingViewController: BaseViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var otpTitleLabel: UILabel!
    @IBOutlet weak var otpDescLable: UILabel!
    @IBOutlet weak var otpContactLable: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var otpShowErrorLable: UILabel!
    @IBOutlet weak var otpResendButton: ButtonWithRightImage!
    @IBOutlet weak var descLabelTopConstraintToTitle: NSLayoutConstraint!
    
    @IBOutlet weak var resendButtonContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resendButtonContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    var emailId: String!
    @IBOutlet weak var descLableTopConstraintToSafeArea: NSLayoutConstraint!
    
    var didPinEntered: ((String) -> Void)?
    
    // MARK: - VC Properties
    var viewModel: OTPVerificationViewModelProtocol?
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreenViews()
        setupOTPTextHandlerView()
        if otpTitleLabel.text == K.Verify_Email_Title {
            self.getOTP(title: otpTitleLabel.text)
        } else if otpTitleLabel.text == K.Verification_Mobile_Tittle || otpTitleLabel.text == K.EMPTY {
            otpContactLable.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if viewModel?.model?.title == K.EMPTY {
            return .lightContent
        }
        return super.preferredStatusBarStyle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    // MARK: - Keyboard Handling
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc  func keyboardWillShow(_ notification: Notification?) {
        
        //  Getting UIKeyboardSize.
        if let info = notification?.userInfo, let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            resendButtonContainerBottomConstraint.constant = kbFrame.size.height + 10
        }
    }
    
    private func setUpScreenViews() {
        otpTitleLabel.setLabelConfig(lblConfig: viewModel?.lblTitleConfig)
        otpDescLable.setLabelConfig(lblConfig: viewModel?.lblDescConfig)
        
        setupAttributedDescLable()
        otpContactLable.setLabelConfig(lblConfig: viewModel?.lblContactConfig)
        otpShowErrorLable.setLabelConfig(lblConfig: viewModel?.lblErrorConfig)
        otpResendButton.setButtonConfig(btnConfig: viewModel?.btnResendConfig)
        self.otpResendButton.isEnabled = true
        self.otpShowErrorLable.isHidden = true
        if otpTitleLabel.text == K.EMPTY {
            self.navigationController?.isNavigationBarHidden = true
            showScreenTitleWithLeftBarButton(screenTitle: "Update mobile number", leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleFont: .mediumFontWithSize(size: 15), screenTitleColor: "", headerBGColor: .themeDarkBlue)
            self.imgView.isHidden = true
        } else {
            showScreenTitleWithLeftBarButton()
            self.navigationController?.navigationBar.backgroundColor = .clear
        }
        if otpTitleLabel.text == K.EMPTY {
            descLableTopConstraintToSafeArea.constant = 92
            descLableTopConstraintToSafeArea.priority = .defaultHigh
            descLableTopConstraint.priority = .defaultLow
            resendButtonContainerTopConstraint.priority = .defaultLow
            resendButtonContainerBottomConstraint.priority = .defaultHigh
        }
        
    }
    private func setResendButton(title: String?, font: UIFont? = nil) {
        if K.Password_Recovery_Resend_Title == title || K.Verify_Email_Resend_Title == title {
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.themeLightBlue]
            let attributedButtonText = NSAttributedString(string: title ?? "", attributes: attributes as [NSAttributedString.Key: Any])
            otpResendButton.setAttributedTitle(attributedButtonText, for: .normal)
            otpResendButton.setImage(#imageLiteral(resourceName: "resend"), for: .normal)
        }
    }
    
    private func setupAttributedDescLable() {
        if let text = otpDescLable.text, text.contains(Config.DEFAULT_COUNTRY_CODE) {
            let nsText = text as NSString
            guard let startIndex = text.firstIndex(of: "+") else {
                return
            }
            let endIndex = text.index(startIndex, offsetBy: (Config.DEFAULT_MOBILE_LIMIT + 2))
            let str = text[startIndex...endIndex]
            let range = nsText.range(of: String(str))
            let attibutedText = NSMutableAttributedString(string: text)
            if otpTitleLabel.text == K.Verify_Email_Title || otpTitleLabel.text == K.EMPTY {
                self.descLableTopConstraint.constant = 0
                otpDescLable.text = text
            } else {
                attibutedText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldFontWithSize(size: 16), range: range)
                otpDescLable.attributedText = attibutedText
            }
        }
    }
    
    private func setupOTPTextHandlerView() {
        pinView.pinLength = 6
        pinView.interSpace = 10
        pinView.textColor = .themeDarkBlue
        pinView.borderLineColor = .themeLightBlue
        pinView.activeBorderLineColor = .themeDarkBlue
        pinView.borderLineThickness = 4
        pinView.activeBorderLineThickness = 4
        pinView.keyboardAppearance = .default
        pinView.tintColor = .white
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        pinView.shouldSecureText = viewModel?.model?.shouldSecureText ?? false
        pinView.font = UIFont.boldFontWithSize(size: 38)
        pinView.keyboardType = .numberPad
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            self.otpShowErrorLable.isHidden = true
        }
    }
    
    private func handleOTPFailure(message: String) {
        self.otpShowErrorLable.text = getErrorMessage(for: message)
        self.otpShowErrorLable.isHidden = false
        pinView.clearPin()
    }
    
    private func getErrorMessage(for message: String) -> String {
        if message.contains(K.Incorrect_OTP) {
            return viewModel?.model?.verificationError ?? "Found Nil while fetchig error message from view model."
        }
        return message
    }
    
    func didFinishEnteringPin(pin: String) {
        self.callVerifyOTP(otp: pin)
    }
    
    override func setupViewModel() {
        viewModel = OTPVerificationViewModel()
        viewModel?.delegate = self
    }
    
    private func callForgotPassword() {
        CommonUtil.sharedInstance.showLoader()
        let request = ForgotPasswordRequest(email: otpContactLable.text ?? "")
        viewModel?.requestForPasswordApi(request: request)
    }
    
    private func callOtpGeneration() {
        CommonUtil.sharedInstance.showLoader()
        
        let otpRequest = OTPGenerationRequest(email: otpContactLable.text, mobile: nil, countryCode: nil)
        viewModel?.requestForOTPGeneration(request: otpRequest)
    }
    
    private func callVerifyOTP(otp: String?) {
        if otpTitleLabel.text == K.Verify_Email_Title || otpTitleLabel.text == K.Password_Recovery_Title {
            let verifyOTPRequest = OTPVerificationRequest(deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "", otp: otp, otpType: "email", email: otpContactLable.text ?? "")
            viewModel?.requestForOTPVerification(request: verifyOTPRequest)
        } else if otpTitleLabel.text == K.Verification_Mobile_Tittle || otpTitleLabel.text == K.EMPTY {
            let verifyMobileRequest = VerifyMobileForWalletRequest(deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "", otp: otp)
            viewModel?.requestVerifyMobileForWallet(request: verifyMobileRequest)
        }
    }
    
    func callWalletRegistartion() {
        print("call wallet registration")
        CommonUtil.sharedInstance.showLoader()
        
        let otpRequest = OTPGenerationRequest(email: nil, mobile: otpContactLable.text ?? "", countryCode: Config.DEFAULT_COUNTRY_CODE)
        viewModel?.requestOTPforWallet(request: otpRequest)
    }
    
    func callResendCodeForMobile() {
        print("call wallet registration")
        CommonUtil.sharedInstance.showLoader()
        let otpRequest = OTPGenerationRequest(email: nil, mobile: otpContactLable.text ?? "", countryCode: Config.DEFAULT_COUNTRY_CODE)
        viewModel?.requestOTPforWallet(request: otpRequest)
    }
    
    func callUpdateCustomerMobile() {
        CommonUtil.sharedInstance.showLoader()
        let request = WalletRegisterRequest(countryCode: Config.countryDict[CommonUtil.countryCode], mobile: otpContactLable.text ?? "")
        viewModel?.requestForUpdateCustomerMobileNo(request: request)
    }
    
    func callGetOtpForMobile() {
        CommonUtil.sharedInstance.showLoader()
        let request = OTPGenerationRequest(email: nil, mobile: otpContactLable.text ?? "", countryCode: Config.DEFAULT_COUNTRY_CODE)
        viewModel?.requestOTPforUpdateMobile(request: request)
        
    }
    
    // MARK: - IBACtions
    
    @IBAction func otpResendButtonAction(_ sender: UIButton) {
        pinView.clearPin()
        otpShowErrorLable.isHidden = true
        self.getOTP(title: otpTitleLabel.text)
    }
    
    private func getOTP(title: String?) {
        switch title {
        case K.Password_Recovery_Title:
            callForgotPassword()
        case K.Verify_Email_Title:
            callOtpGeneration()
        case K.Verification_Mobile_Tittle:
            callResendCodeForMobile()
        case K.EMPTY:
            callGetOtpForMobile()
        default:
            debugPrint("Title: \(title ?? "") Not known.")
        }
    }
    
    // MARK: - Navigation
    private func navigateToNextVC(title: String?) {
        switch title {
        case K.Password_Recovery_Title:
            navigateToCreatePasswordVC()
        case K.Verify_Email_Title:
            navigateToTnCVC()
        case K.Verification_Mobile_Tittle:
            navigateEnterPinVC()
        case K.EMPTY:
         ///call update customer
            callUpdateCustomerMobile()
        default:
            debugPrint("Title: \(title ?? "") Not known.")
        }
    }
    
    private func navigateToCreatePasswordVC() {
        let vc = CreateNewPasswordViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Login, storyboardId: StoryboardId.CreateNewPasswordVC)
        vc.emailId = otpContactLable.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTnCVC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// This method loads WalletRegistration VC
    private  func navigateEnterPinVC() {
        if viewModel?.model?.mobileOTPType == .updatePin {
            let vc = CurrentPinViewController.instantiateFromStoryboard(storyboardName: StoryboardName.CurrentPin, storyboardId: StoryboardId.CurrentPinViewController)
            vc.viewModel?.mobileOTPType = viewModel?.model?.mobileOTPType
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = EnterPinViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.EnterPinViewController)
        vc.viewModel?.mobileOTPType = viewModel?.model?.mobileOTPType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToPasswordSuccesVC() {
        let vc = NotificationSuccessViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationSuccessViewController)
        let noticationSuccessModel = NotificationSuccessModel(titleText: NotificationMessage.mobileNoUpdateMessage, successButtonText: localizedStringForKey(key: "button.title.back_to_wallet"))
        vc.viewModel?.dataModel = noticationSuccessModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - OTPVerificationDataPassingDelegate
extension OTPHandlingViewController: OTPVerificationDataPassingDelegate {
    func updateMobileNoSuccessAction() {
        navigateToPasswordSuccesVC()
    }
    
    func updateMobileNoFailureAction(message: String) {
     CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func verifyMobileSuccessAction() {
        navigateToNextVC(title: otpTitleLabel.text)
    }
    
    func verifyMobileFailureAction(message: String) {
        handleOTPFailure(message: message)
    }
    
    func getWalletOTPSucces() {
        CommonUtil.sharedInstance.removeLoader()
    }
    
    func getWalletOTPFailure(message: String) {
        handleOTPFailure(message: message)
    }
    
    func forgotFailureHandler(message: String) {
        handleOTPFailure(message: message)
    }
    
    func forgotSuccessHandler() {
        debugPrint("Forgot Success")
    }
    
    func getOTPSuccess() {
        debugPrint("Get Otp Success")
    }
    
    func getOTPFailure(message: String) {
        handleOTPFailure(message: message)
    }
    
    func performOTPVerificationSuccessAction() {
        navigateToNextVC(title: otpTitleLabel.text)
    }
    
    func performOTPVerificationFailureAction(message: String) {
        handleOTPFailure(message: message)
    }
    
}
