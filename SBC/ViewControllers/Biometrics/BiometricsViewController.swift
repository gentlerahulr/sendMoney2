import UIKit
import LocalAuthentication

class BiometricsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imgViewTop: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblFaceId: UILabel!
    @IBOutlet weak var btnFaceId: UIButton!
    @IBOutlet weak var lblTouchId: UILabel!
    @IBOutlet weak var btnTouchId: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var containerViewFaceId: UIView!
    @IBOutlet weak var containerViewTouchId: UIView!
    
    // MARK: - Properties
    var viewModel: BiometricsViewModelProtocol?
    
    override func setupViewModel() {
        viewModel = BiometricsViewModel()
        viewModel?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton()
        setupUI()
    }
    
    func setupUI() {
        lblDesc.setLabelConfig(lblConfig: viewModel?.lblDescConfig)
        lblFaceId.setLabelConfig(lblConfig: viewModel?.lblFaceIdConfig)
        lblTouchId.setLabelConfig(lblConfig: viewModel?.lblTouchIdConfig)
        btnContinue.setButtonConfig(btnConfig: viewModel?.btnContinueConfig)
        guard let vModel = viewModel else {
            return
        }
        
        containerViewFaceId.isHidden = !vModel.isFaceIdAvailable
        containerViewTouchId.isHidden = !vModel.isTouchIdAvailable
    }
    
    @IBAction func btnFaceIdAction(_ sender: UIButton) {
        if !sender.isSelected {
            authenticationWithBiometric(button: sender)
        } else {
            sender.isSelected = false
            UserDefaults.standard.isWalletBiometricEnabled = false
        }
    }
    @IBAction func btnTouchIdAction(_ sender: UIButton) {
        if !sender.isSelected {
            authenticationWithBiometric(button: sender)
        } else {
            sender.isSelected = false
            UserDefaults.standard.isWalletBiometricEnabled = false
        }
    }
    @IBAction func btnContinueAction(_ sender: UIButton) {
        navigateToTOC()
    }
    
    override func leftButtonAction(button: UIButton) {
        showActionPopup(parentView: self.view)
    }
    
    /// This function authenticates WithvBiometric
    /// - Parameter button: button to enable
    func authenticationWithBiometric(button: UIButton) {
        LAContext.authenticationWithBiometric(fallbackTitle: localizedStringForKey(key: "biometrics_reason"), viewController: self, completion: { result in
            DispatchQueue.main.async {
                if result {
                    button.isSelected = true
                    UserDefaults.standard.isWalletBiometricEnabled = true
                    
                } else {
                    CommonAlertHandler.showErrorResponseAlert(for: localizedStringForKey(key: "biometrics_auth_failure_msg"))
                }
            }
        })
    }
    
    private func showActionPopup(parentView: UIView) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "ARE_YOU_SURE"), descText: localizedStringForKey(key: "WALLET_REGISTRATION_PROGRESS_DESC"), positiveButtonText: localizedStringForKey(key: "YES_ACTION"), negativeButtonText: localizedStringForKey(key: "STAY_CONTINUE"))
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
}

extension BiometricsViewController: BiometricsDataPassingDelegate {
    func performBiometricsSuccessAction() {
    }
    
    func performBiometricsFailureAction(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
}

// MARK: - Navigation
extension BiometricsViewController {
    func navigateToTOC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        vc.viewModel?.isWalletTnC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
