//
//  TnCViewController.swift
//  SBC

import UIKit
import WebKit

class TnCViewController: BaseViewController {
    
    @IBOutlet weak var labelTnCTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonCheckbox: UIButton!
    @IBOutlet weak var labelAccept: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var leadingWebViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingWebViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLableTnCTitleConstraint: NSLayoutConstraint!
    
    var viewModel: TnCViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTnCScreen()
    }
    
    override func setupViewModel() {
        viewModel  = TnCViewModel()
        viewModel?.delegate = self
    }
    
    //This method loads TnC url
    func loadTnCScreen() {
        showScreenTitleWithLeftBarButton()
        labelAccept.setLabelConfig(lblConfig: viewModel?.labelAcceptConfig)
        labelTnCTitle.setLabelConfig(lblConfig: viewModel?.labelTnCTitleConfig)
        buttonAccept.setTitleColor(.themeDarkBlueTint1, for: .disabled)
        self.webView.navigationDelegate = self
        if viewModel?.isWalletTnC ?? false {
            labelTnCTitle.isHidden = true
            viewModel?.callGetWalletTnC()
            leadingWebViewConstraint.constant = 0
            trailingWebViewConstraint.constant = 0
            topLableTnCTitleConstraint.constant = 0
        } else {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "terms_condition", ofType: "html")!)
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        if viewModel?.isWalletTnC ?? false {
            guard  !CommonUtil.countryCode.isEmpty, !CommonUtil.userEmail.isEmpty, !CommonUtil.userMobile.isEmpty else {
                CommonAlertHandler.showErrorResponseAlert(for: "Found Nil while fetching user details.")
                return
            }
            let request = MinimalCustomerDataRequest(email: CommonUtil.userEmail, countryCode: Config.countryDict[CommonUtil.countryCode], mobile: CommonUtil.userMobile, customerHashId: CommonUtil.customerHashID, walletHashId: CommonUtil.walletHashID)
            viewModel?.callAddCoustomerWithMinimalData(request: request)
        } else {
            let request = UpdateTnCStatusRequest(tncStatus: true)
            viewModel?.callUpdateTnCStatusAPI(request: request)
        }
    }
    
    @IBAction func buttonCheckboxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        setAcceptButtonState(active: sender.isSelected)
    }
    
    private func setAcceptButtonState(active: Bool) {
        if active {
            buttonAccept.backgroundColor = .themeDarkBlue
            buttonAccept.isEnabled = true
            buttonAccept.setTitleColor(.themeDarkBlue, for: .selected)
        } else {
            buttonAccept.backgroundColor = .themeDarkBlueTint2
            buttonAccept.isEnabled = false
            buttonAccept.setTitleColor(.themeDarkBlueTint1, for: .disabled)
        }
    }
    
    override func leftButtonAction(button: UIButton) {
        if viewModel?.isWalletTnC ?? false {
            showActionPopup(parentView: self.view)
        } else {
            RootViewControllerRouter.setHomeNavAsRootVC(animated: false)
        }
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

extension TnCViewController: WKNavigationDelegate, WKUIDelegate {
    
    //Decides whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        print("navigationAction load:\(String(describing: navigationAction.request.url))")
        decisionHandler(.allow)
    }
    
    //Start loading web address
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        CommonUtil.sharedInstance.showLoader()
        print("start load:\(String(describing: webView.url))")
    }
    
    //Fail while loading with an error
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        CommonUtil.sharedInstance.removeLoader()
        print("fail with error: \(error.localizedDescription)")
    }
    
    //WKWebView finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CommonUtil.sharedInstance.removeLoader()
        print("finish loading")
    }
}

extension TnCViewController: TnCDataPassingDelegate {
    func updatewalletDataSuccess() {
        navigateToMyInfo(redirectUrl: viewModel?.redirectUrl)
    }
    
    func successHandler() {
        UserDefaults.standard.isLoggedIn = true
        RootViewControllerRouter.setTabbarAsRootVC(animated: false)
    }
    
    func failureHandler(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func walletSuccessHandler(response: GetWalletTnCResponse) {
        webView.loadHTMLString(response.description, baseURL: nil)
    }
    
}
// MARK: - Navigation
extension TnCViewController {
    private func navigateToMyInfo(redirectUrl: String?) {
        let vc = MyInfoViewController.instantiateFromStoryboard(storyboardName: StoryboardName.MyInfo, storyboardId: StoryboardId.MyInfoViewController)
        vc.viewModel?.redirectUrl = redirectUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
