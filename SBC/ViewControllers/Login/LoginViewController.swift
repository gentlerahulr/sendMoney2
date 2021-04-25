//
//  LoginViewController.swift
//  SBC
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices
import JVFloatLabeledTextField

// This is the login screen of the app having different resister with options.
class LoginViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var heightConstraintErrorLabel: NSLayoutConstraint!
    @IBOutlet weak var buttonLoginWithFB: FBLoginButton!
    @IBOutlet weak var buttonContinueWithApple: UIButton!
    @IBOutlet weak var textFieldEmail: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldPassword: JVFloatLabeledTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonBiometric: UIButton!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var lableErrorEmailPassword: UILabel!
    @IBOutlet weak var lableErrorNotRegistered: UILabel!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var buttonEye: UIButton!
    @IBOutlet weak var buttonForget: UIButton!
    @IBOutlet weak var heightErrorConstraint: NSLayoutConstraint!
    
    let loginManager = LoginManager()
    var loginViewModel: LoginViewModelProtocol?
    
    // MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addFBLoginButton()
        configureUIInitialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func setupViewModel() {
        self.loginViewModel = LoginViewModel()
        self.loginViewModel?.delegate = self
    }
    
    /// This method configures the UI initialization
    func configureUIInitialization() {
        heightErrorConstraint.constant = 0
        buttonLogin.setTitleColor(UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0), for: .normal)
        buttonLogin.setTitleColor(UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint2, alpha: 1.0), for: .disabled)
        buttonLogin.isEnabled = false
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        if #available(iOS 13.0, *) {
            buttonContinueWithApple.isHidden = false
        } else {
            buttonContinueWithApple.isHidden = true
        }
    }
    
    func clearScreen() {
        heightErrorConstraint.constant = 0
        textFieldEmail.text = ""
        textFieldPassword.text = ""
        lableErrorEmailPassword.isHidden = true
        lableErrorNotRegistered.isHidden = true
        labelErrorEmail.isHidden = true
        labelErrorPassword.isHidden = true
        viewEmail.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
        buttonEye.isSelected = false
    }
}

// MARK: IBActions
extension LoginViewController {
    @IBAction func loginWithFBTapped(_ sender: Any) {
        clearScreen()
        fbLoginLogic()
    }
    
    @IBAction func continueWithAppleTapped(_ sender: Any) {
        clearScreen()
        if #available(iOS 13.0, *) {
            handleLogInWithAppleID()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //Create login request with appropriate data.
        let loginRequest = LoginRequest(deviceId: K.deviceId, email: textFieldEmail.text ?? "", password: textFieldPassword.text ?? "", loginType: "email", facebookId: "", appleId: "")
            KeyChainServiceWrapper.standard.userEmail = loginRequest.email
        loginViewModel?.callLoginAPI(loginRequest: loginRequest)        
    }
    
    @IBAction func biometricTapped(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let vc = PasswordRecoveryViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Login, storyboardId: StoryboardId.PasswordRecoveryVC)
        vc.showScreenTitleWithLeftBarButton()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        RootViewControllerRouter.setHomeNavAsRootVC(animated: true)
    }
    
    @IBAction func eyeTapped(_ sender: Any) {
        buttonEye.isSelected = !(buttonEye.isSelected)
        textFieldPassword.isSecureTextEntry = !(buttonEye.isSelected)
    }
}

// MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        buttonLogin.isEnabled = false
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if CommonValidation.isValidEmail(textFieldEmail.text!) && textFieldPassword.text != ""{
            buttonLogin.isEnabled = true
            buttonLogin.borderColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
        } else {
            buttonLogin.isEnabled = false
            buttonLogin.borderColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint2, alpha: 1.0)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldEmail.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPassword.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lableErrorNotRegistered.isHidden = true
        lableErrorEmailPassword.isHidden = true
        heightErrorConstraint.constant = 0
        if !CommonValidation.isValidEmail(textFieldEmail.text!) && textField == textFieldEmail {
            labelErrorEmail.isHidden = false
            viewEmail.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeRed, alpha: 1.0)
        } else {
            labelErrorEmail.isHidden = true
            viewEmail.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
        }
    }
    
    func textField(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        lableErrorNotRegistered.isHidden = true
        lableErrorEmailPassword.isHidden = true
        heightErrorConstraint.constant = 0
        if !CommonValidation.isValidEmail(textFieldEmail.text!) && textField == textFieldEmail {
            labelErrorEmail.isHidden = false
            viewEmail.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeRed, alpha: 1.0)
        } else {
            labelErrorEmail.isHidden = true
            viewEmail.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
        }
        return true
    }
}

extension LoginViewController: LoginDataPassingDelegate {
    func loginFailureWithError(message: String) {
        if message == K.User_Not_Found {
            lableErrorNotRegistered.isHidden = false
        } else if message == K.Incorrect_Creds {
            lableErrorEmailPassword.isHidden = false
            heightErrorConstraint.constant = 42
        } else {
             CommonAlertHandler.showErrorResponseAlert(for: message)
        }
    }
    
    func didLoginSuccess(loginResponse: LoginResponse) {
        if loginResponse.isEmailVerified == false {
            navigateToEmailVerificationErrorVC()
        } else if loginResponse.tncStatus == false {
            self.navigateToTnCVC()
        } else {
            UserDefaults.standard.isLoggedIn = true
            //Navigate to appropriate controller
            navigateToDashBoardVC()
        }
    }
}

// MARK: - Navigation
extension LoginViewController {
    /// This method loads Dashboard VC
    func navigateToDashBoardVC() {
        var index = 0
        if let tabBarVC = self.tabBarController as? TabbarController {
            index = tabBarVC.previousSelectedTabBarIndex
        }
        RootViewControllerRouter.setTabbarAsRootVC(animated: false, initialVCIndex: index)
    }
    
    private func navigateToEmailVerificationErrorVC() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationViewController)
        let model  = NotificationModel(imageName: "Oops!", title: localizedStringForKey(key: "notification_label_title"), desc: localizedStringForKey(key: "notification_label_desc"), contact: textFieldEmail.text ?? "", btnTitle: localizedStringForKey(key: "notification_btn_resend_email"))
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTnCVC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
