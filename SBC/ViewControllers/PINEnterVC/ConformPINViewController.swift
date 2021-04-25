//
//  ConformPINViewController.swift
//  SBC

import UIKit

class ConformPINViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonNewPin: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var buttonNewPINBottomConstraint: NSLayoutConstraint!
    
    let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
    
    var setPin: String?
    var errorStr: String?
    var viewModel: ConfomPinViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopUI()
    }
    
    private func setupTopUI() {
        tableView.dataSource = self
        tableView.delegate = self
        registerNib()
        setUpHeader()
        var topHeight: CGFloat = 70
        if viewModel?.model?.mobileOTPType == .updatePin {
            topHeight = 110
        }
        self.tableView.contentInset = UIEdgeInsets(top: topHeight, left: 0, bottom: 0, right: 0)
        
        if viewModel?.model?.mobileOTPType == .updatePin {
            buttonNewPin.setTitle(localizedStringForKey(key: "button.title.enter_new_pin"), for: .normal)
        } else {
            buttonNewPin.setTitle( localizedStringForKey(key: "CREATE_NEW_PIN"), for: .normal)
        }
    }
    
    private func setUpHeader() {
        if viewModel?.model?.mobileOTPType == .updatePin {
            showScreenTitleWithLeftBarButton(screenTitle: viewModel?.model?.screenTitle, leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleColor: colorConfig.dark_navigation_header_text_color, headerBGColor: .themeDarkBlue)
            backgroundImage.isHidden = true
        } else {
            showScreenTitleWithLeftBarButton()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    override func setupViewModel() {
        viewModel = ConfomPinViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if viewModel?.model?.mobileOTPType == .updatePin {
            return .lightContent
        }
        return super.preferredStatusBarStyle
    }
    
    private func registerNib() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PinEnteryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PinEnteryTableViewCell")
    }
    
    // MARK: - Keyboard Handling
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
    }
    
    @objc  func keyboardWillShow(_ notification: Notification?) {
        
        //  Getting UIKeyboardSize.
        if let info = notification?.userInfo, let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            buttonNewPINBottomConstraint.constant = kbFrame.size.height
        }
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
            config.strlabelTitle = viewModel?.model?.title
            config.strLableShowError = localizedStringForKey(key: "PIN_NOT_MATCHED")
            if viewModel?.model?.mobileOTPType == .updatePin {
                config.strBtn = localizedStringForKey(key: "button.title.enter_new_pin")
            } else {
                config.strBtn = localizedStringForKey(key: "CREATE_NEW_PIN")
            }
            cell.configureCell(config: config)
            cell.didPinEntered = didPinEnteredVC(pin:)
            cell.buttonResend.isHidden = true
            cell.imgView.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    private func getPinCell() -> PinEnteryTableViewCell? {
        return tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PinEnteryTableViewCell
    }
    
    func didPinEnteredVC(pin: String) {
        let cell = getPinCell()
        if pin != viewModel?.model?.setPin {
            cell?.pinView.clearPin()
            cell?.lableShowError.isHidden = false
        } else {
            cell?.lableShowError.isHidden = true
            viewModel?.requestCreatePin(request: MpinRequest(mpin: pin))
        }
        tableView.reloadData()
    }
    
    // MARK: Button Action
    @IBAction func didTapNewPin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToBiometric() {
        let vc = BiometricsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Biometrics, storyboardId: StoryboardId.BiometricsViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToNotification(title: String, buttonText: String) {
        let vc = NotificationSuccessViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationSuccessViewController)
        vc.viewModel?.dataModel = NotificationSuccessModel(titleText: title, successButtonText: buttonText)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToTOC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        vc.viewModel?.isWalletTnC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConformPINViewController: ConfomPinPassingDelegate {
    func confirmSuccess() {
        if viewModel?.model?.mobileOTPType == .forgotPin || viewModel?.model?.mobileOTPType == .updatePin {
            var buttonText = localizedStringForKey(key: "button.title.go_to_wallet")
            if viewModel?.model?.mobileOTPType == .updatePin {
                buttonText = localizedStringForKey(key: "button.title.back_to_wallet")
            }
            navigateToNotification(title: localizedStringForKey(key: "notification.pin.update.message"), buttonText: buttonText)
        } else {
            if let biometrciType = viewModel?.biometrciType, biometrciType == .none {
                navigateToTOC()
                return
            }
            navigateToBiometric()
        }
    }
    
    func confirmFailure(message: String) {
        getPinCell()?.pinView.clearPin()
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
}
