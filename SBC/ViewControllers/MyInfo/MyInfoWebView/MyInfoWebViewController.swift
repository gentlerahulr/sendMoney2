//
//  MyInfoWebViewController.swift
//  SBC

import UIKit
import WebKit

class MyInfoWebViewController: BaseViewController {
    
    @IBOutlet weak var webViewMyInfo: WKWebView!
    var appLoader = AppLoaderView()
    var redirectUrl: String?
    
    var viewModel: MyInfoWebViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonUtil.sharedInstance.showLoader()
        webViewMyInfo.navigationDelegate = self
        if let redirect = redirectUrl, let encodedUrl = redirect.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedUrl) {
            webViewMyInfo.load(URLRequest(url: url))
        }
    }
    
    override func setupViewModel() {
        viewModel = MyInfoWebViewModel()
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
extension MyInfoWebViewController: WKNavigationDelegate {
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
            if navigationUrlString.contains(CommonUtil.customerHashID) {
                decisionHandler(.cancel)
                viewModel?.getCustomerDetails(customerHasId: CommonUtil.customerHashID)
                return
            } else if navigationUrlString == "failed" {
                decisionHandler(.cancel)
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        decisionHandler(.allow)
    }
}

extension MyInfoWebViewController {
    func navigateTOMyInfoDetailsVC(customer: Customer) {
        let vc = MyInfoDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.MyInfo, storyboardId: StoryboardId.MyInfoDetailsViewController)
        vc.viewModel?.customerDetails = customer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToNotification(imageName: String, title: String, desc: String, buttonText: String) {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationViewController)
        let model  = NotificationModel(imageName: imageName, title: title, desc: desc, contact: "", btnTitle: buttonText)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyInfoWebViewController: MyInfoWebViewDataPassingDelegate {
    func failureWithError(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func getCustomerDataSucces(response: Customer) {
        if response.complianceStatus?.lowercased() != "COMPLETED".lowercased() {
            if let viewControllers = self.navigationController?.viewControllers, let vc = viewControllers[viewControllers.count - 2] as? MyInfoViewController {
                var complianceRemarks: String = response.complianceRemarks ?? ""
                if complianceRemarks.contains("already used by other customer") {
                    complianceRemarks = localizedStringForKey(key: "myinfo.error.already.registered.user")
                }
                vc.viewModel?.redirectUrl = nil
                vc.viewModel?.errorMessage = complianceRemarks
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
        navigateTOMyInfoDetailsVC(customer: response)
    }
}
