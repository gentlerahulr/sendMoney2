//
//  MyInfoDetailsViewController.swift
//  SBC

import UIKit

class MyInfoDetailsViewController: BaseViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDOB: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    
    var viewModel: MyInfoDetailsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScreenTitleWithLeftBarButton()
        setContinueButtonState(active: false)
        setupCustomreDetailsUI()
    }
    
    func setupCustomreDetailsUI() {
        labelName.text = viewModel?.customerDetails?.fullName
        labelDOB.text = viewModel?.customerDetails?.dateOfBirth
        labelAddress.text = viewModel?.customerDetails?.fullBillingAddress
        if (viewModel?.customerDetails?.fullName ?? "").isBlank || viewModel?.customerDetails?.dateOfBirth?.isEmpty ?? true {
            setContinueButtonState(active: false)
        } else {
            setContinueButtonState(active: true)
        }
    }
    
    override func setupViewModel() {
        viewModel = MyInfoDetailsViewModel()
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
    
    private func setContinueButtonState(active: Bool) {
        if active {
            buttonContinue.backgroundColor = .themeDarkBlue
            buttonContinue.isEnabled = true
        } else {
            buttonContinue.backgroundColor = .themeDarkBlueTint2
            buttonContinue.isEnabled = false
        }
    }
    
    @IBAction func buttonConfirmDetailsTapped(_ sender: Any) {
        let request = UpdateWalletRegisteredRequest(isWalletRegistered: true, customerHashId: CommonUtil.customerHashID, walletHashId: CommonUtil.walletHashID)
        viewModel?.callUpdateWalletStatus(request: request)
    }
    
    func navigateToNotification(imageName: String, title: String, desc: String, buttonText: String) {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: imageName, title: title, desc: desc, contact: "", btnTitle: buttonText, backgroundColor: ColorHex.ThemeNeonBlue)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyInfoDetailsViewController: MyInfoDetailsDataPassingDelegate {
    func failureWithError(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func success() {
        navigateToNotification(imageName: "Success", title: localizedStringForKey(key: "wallet_success_label_title"), desc: localizedStringForKey(key: "wallet_success_label_desc"), buttonText: localizedStringForKey(key: "wallet_success_btn"))
    }
}
