//
//  TNCForWalletViewController.swift
//  SBC

import UIKit
import WebKit

class TNCForWalletViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    var viewModel: TNCForWalletViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTnCScreen()
    }
    
    override func setupViewModel() {
       viewModel = TNCForWalletViewModel()
        viewModel?.delegate = self
    }
    
    func loadTnCScreen() {
        self.navigationController?.isNavigationBarHidden = true
        showScreenTitleWithLeftBarButton(screenTitle: "Terms and conditions", leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleFont: .mediumFontWithSize(size: 15), screenTitleColor: "", headerBGColor: .themeDarkBlue)
        self.webView.navigationDelegate = self
        viewModel?.callGetWalletTnC()
    }

}

extension TNCForWalletViewController: TNCForWalletPassingDelegate {
    func failureHandler(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func walletSuccessHandler(response: GetWalletTnCResponse) {
        webView.loadHTMLString(response.description, baseURL: nil)
    }
}

extension TNCForWalletViewController: WKNavigationDelegate, WKUIDelegate {
    
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
