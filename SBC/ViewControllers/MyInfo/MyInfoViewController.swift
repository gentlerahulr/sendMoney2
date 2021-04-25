//
//  MyInfoViewController.swift
//  SBC

import UIKit

class MyInfoViewController: BaseViewController {
    
    @IBOutlet weak var labelErrorForAlreadyReg: UILabel!
    @IBOutlet weak var labeldesc: UILabel!
    
    var viewModel: MyInfoViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton()
        labeldesc.setLabelConfig(lblConfig: viewModel?.labelDescConfig)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let errormessage = viewModel?.errorMessage {
            labelErrorForAlreadyReg.isHidden = false
            labelErrorForAlreadyReg.text = errormessage
            
        } else {
            labelErrorForAlreadyReg.isHidden = true
        }
    }
    
    override func setupViewModel() {
        viewModel = MyInfoViewModel()
        viewModel?.delegate = self
    }
    
    override func leftButtonAction(button: UIButton) {
        showActionPopup(parentView: self.view)
    }
    
    private func showActionPopup(parentView: UIView) {
        self.view.endEditing(true)
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
    
    private func showPoorConnectionPopup(parentView: UIView) {
        self.view.endEditing(true)
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "popup.poor.connection.title"), descText: localizedStringForKey(key: "popup.poor.connection.desc"), positiveButtonText: localizedStringForKey(key: "button.title.try_again"), negativeButtonText: "")
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction  = { [weak self] in
            self?.loginSignPassAction()
        }
        parentView.addSubview(actionPopupView)
    }
    
    private func loginSignPassAction() {
        if !NetworkReachabilityStatus.isConnected() {
            showPoorConnectionPopup(parentView: self.view)
            return
        }
        if let redirectUrl = viewModel?.redirectUrl {
            navigateToMyInfoWebView(redirectUrl: redirectUrl)
        } else if let request = viewModel?.minimalCustomerDataRequest {
            viewModel?.callAddCoustomerWithMinimalData(request: request)
        }
    }
    
    @IBAction func loginSingPassTapped(_ sender: Any) {
        loginSignPassAction()
    }
    
    func navigateToMyInfoWebView(redirectUrl: String) {
        let vc = MyInfoWebViewController.instantiateFromStoryboard(storyboardName: StoryboardName.MyInfo, storyboardId: StoryboardId.MyInfoWebViewController)
        vc.redirectUrl = redirectUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyInfoViewController: MyInfoDataPassingDelegate {
    func performMinimalCoustmerSuccess(response: MinimalCustomerDataResponse) {
        navigateToMyInfoWebView(redirectUrl: response.redirectUrl)
    }
    
    func performMinimalCoustmerfailure(message: String) {
        if message.contains("Internet connection appears to be offline") || message.contains("The request timed out") {
            showPoorConnectionPopup(parentView: self.view)
        } else {
            CommonAlertHandler.showErrorResponseAlert(for: message)
        }
        
    }
}
