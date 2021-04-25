//
//  StripeUIWebviewViewController.swift
//  SBC

import UIKit
import WebKit

class StripeUIWebviewViewController: BaseViewController {
    
    var appLoader = AppLoaderView()
    var viewModel: StripeUIWebViewModelProtocol?
    let successRedirectURL = "https://www.onz.com/fund/callback/%@"
    @IBOutlet weak var webViewStripUI: WKWebView!
    let defaults = UserDefaults.standard
    var apiHitCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonUtil.sharedInstance.showLoader()
        webViewStripUI.navigationDelegate = self
        if let redirect = viewModel?.redirectURL, let encodedUrl = redirect.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedUrl) {
            webViewStripUI.load(URLRequest(url: url))
        }
    }
    
    override func setupViewModel() {
        viewModel = StripeUIWebViewModel()
        viewModel?.delegate = self
    }
    
    func addLoader() {
        CommonUtil.sharedInstance.showLoader()
    }
    
    func removeLoader() {
        CommonUtil.sharedInstance.removeLoader()
    }
}

// MARK: - WebView Navigation
extension StripeUIWebviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        addLoader()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        addLoader()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        removeLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let navigationUrlString = navigationAction.request.url?.absoluteString {
            addLoader()
            
            //TO DO: Need to change after getting correct url.
            debugPrint("NavigateURL: \(navigationUrlString)")
            if let systemRefno = viewModel?.topUpCardFundResponse?.systemReferenceNumber {
                let successURL = String(format: successRedirectURL, systemRefno)
                if navigationUrlString == successURL {
                    decisionHandler(.allow)
                    viewModel?.getTransactionUsingSystemRefNo(systemReferanceNo: systemRefno)
                    return
                } else if navigationUrlString == "failed" {
                    decisionHandler(.cancel)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
       
        }
        decisionHandler(.allow)
    }
}

extension StripeUIWebviewViewController: StripeUIWebViewDataPassingDelegate {
    
    func failureWithError(message: String) {
        navigateToFailureTrasanction()
    }
    
    func getTransactionSucces(response: TopUpCardTransactionResponse) {
        if response.content.first?.status == "Approved" {
            navigateToSuccessTransaction(response: response)
            apiHitCount = 0
        } else if response.content.first?.status == "Failed" || response.content.first?.status == "Declined" {
            navigateToFailureTrasanction()
            apiHitCount = 0
        } else if response.content.first?.status == "Pending" {
            if apiHitCount != defaults.maximumNumberAPIRetry {
                apiHitCount += 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(defaults.apiDelay)) {
                    if let systemRefno = self.viewModel?.topUpCardFundResponse?.systemReferenceNumber {
                        self.viewModel?.getTransactionUsingSystemRefNo(systemReferanceNo: systemRefno)
                    }
                }
            } else {
                navigateToFailureTrasanction()
                apiHitCount = 0
            }
        }
    }
}

extension StripeUIWebviewViewController {
    
    func navigateToSuccessTransaction (response: TopUpCardTransactionResponse) {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let successMessage = String(format: localizedStringForKey(key: "top.up.success.message"), response.content.first?.billingAmount.getDecimalGroupedAmount() ?? 0.00)
        let model  = NotificationModel(imageName: ImageConstants.SuccessTopUp, title: successMessage, desc: "", contact: "",
                                       btnTitle: localizedStringForKey(key: "button.title.back_to_wallet"),
                                       backgroundColor: ColorHex.ThemeNeonBlue)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToFailureTrasanction() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.Oops, title: localizedStringForKey(key: "transaction.failure.card"),
                                       desc: "", contact: "", btnTitle: localizedStringForKey(key: "button.title.topUP"),
                                       backgroundColor: ColorHex.ThemeRed)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
