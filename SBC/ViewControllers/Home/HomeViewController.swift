//
//  HomeViewController.swift
//  SBC

// This is the landing screen of the app having different resister with options.
import UIKit
import FBSDKLoginKit

class HomeViewController: NavigationController, SignUpViewModelDelegate {
    
    // MARK: Button Outlets
    @IBOutlet weak var buttonRegisterWithEmail: UIButton!
    @IBOutlet weak var lableErrorAlreadyRegistered: UILabel!
    @IBOutlet weak var buttonRegisterWithFB: UIButton!
    @IBOutlet weak var buttonRegisterWithApple: UIButton!
    var singUpViewModel = SignUpViewModel()
    
    let loginManager = LoginManager()
    
    // MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIInitialization()
    }
    
    /// This method configures the UI initialization
    func configureUIInitialization() {
        singUpViewModel.delegate = self
        buttonRegisterWithApple.isExclusiveTouch = true
        buttonRegisterWithFB.isExclusiveTouch = true
        buttonRegisterWithEmail.isExclusiveTouch = true
        
        if #available(iOS 13.0, *) {
            buttonRegisterWithApple.isHidden = false
        } else {
            buttonRegisterWithApple.isHidden = true
        }
    }
    
    // MARK: Button IBActions
    @IBAction func registerWithFBTapped(_ sender: Any) {
        lableErrorAlreadyRegistered.isHidden = true
        fbLoginLogic()
    }
    
    @IBAction func registerWithEmailTapped(_ sender: Any) {
        lableErrorAlreadyRegistered.isHidden = true
        let vc = SignUpViewController.instantiateFromStoryboard(storyboardName: StoryboardName.RegisterWihEmail, storyboardId: StoryboardId.SignUpViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerWithAppleTapped(_ sender: Any) {
        lableErrorAlreadyRegistered.isHidden = true
        if #available(iOS 13.0, *) {
            handleLogInWithAppleID()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        RootViewControllerRouter.setLoginNavAsRootVC(animated: true)
    }
    
    func navigateToTnCVC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ViewModel Methods
    
    func signUpFailureWithError(message: String) {
        if message == K.Email_Already_Exist {
            lableErrorAlreadyRegistered.isHidden = false
        } else {
            CommonAlertHandler.showErrorResponseAlert(for: message)
        }
    }
    
    func signUpSuccess(signUpResponse: SignUpResponse) {
        self.navigateToTnCVC()
    }
}
