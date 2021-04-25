//
//  EnterPinViewController.swift
//  SBC

import UIKit

class EnterPinViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var viewModel: EnterPinViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPinCell()?.pinView.clearPin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupViewModel() {
        viewModel = EnterPinViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if viewModel?.mobileOTPType == .updatePin {
            return .lightContent
        }
        return super.preferredStatusBarStyle
    }
    
    func setUpUi() {
        tableview.dataSource = self
        tableview.delegate = self
        registerNib()
        setUpHeader()
        var topHeight: CGFloat = 70
        if viewModel?.mobileOTPType == .updatePin {
            topHeight = 110
        }
        self.tableview.contentInset = UIEdgeInsets(top: topHeight, left: 0, bottom: 0, right: 0)
        
    }
    
    private func setUpHeader() {
        if viewModel?.mobileOTPType == .updatePin {
            showScreenTitleWithLeftBarButton(screenTitle: viewModel?.screenTitle, leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleColor: colorConfig.dark_navigation_header_text_color, headerBGColor: .themeDarkBlue)
            backgroundImageView.isHidden = true
        } else {
            showScreenTitleWithLeftBarButton()
        }
    }
    
    private func registerNib() {
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "PinEnteryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PinEnteryTableViewCell")
    }
    
    private func getPinCell() -> PinEnteryTableViewCell? {
        return tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? PinEnteryTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PinEnteryTableViewCell", for: indexPath) as? PinEnteryTableViewCell {
            var config = PinEnteryTableViewCellConfig()
            config.strlabelTitle = viewModel?.title
            cell.configureCell(config: config)
            cell.didPinEntered = didPinEnteredVC(pin:)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func didPinEnteredVC(pin: String) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigateToComfirmPin(pin: pin)
        }
    }
    
    override func leftButtonAction(button: UIButton) {
        if MobileOTPType.forgotPin == viewModel?.mobileOTPType || MobileOTPType.updatePin == viewModel?.mobileOTPType {
            super.leftButtonAction(button: button)
        } else {
            showActionPopup(parentView: self.view)
        }
    }
    
    func navigateToComfirmPin(pin: String) {
        let vc = ConformPINViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.ConformPINViewController)
        if MobileOTPType.updatePin == .updatePin {
            let model = ConfomPinModel(setPin: pin, title: localizedStringForKey(key: "update.pin.confirm.new.pin.title"), screenTitle: localizedStringForKey(key: "update.pin.screen.title"), mobileOTPType: viewModel?.mobileOTPType)
            vc.viewModel?.model = model
        } else {
            let model = ConfomPinModel(setPin: pin, title: localizedStringForKey(key: "CONFIRM_PIN"), mobileOTPType: viewModel?.mobileOTPType)
            vc.viewModel?.model = model
        }
        vc.setPin = pin
        self.navigationController?.pushViewController(vc, animated: true)
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
}

extension EnterPinViewController: EnterPinDataPassingDelegate {
    
}
