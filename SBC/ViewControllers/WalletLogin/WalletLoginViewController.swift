import UIKit
import LocalAuthentication

class WalletLoginViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBiometric: UIButton!
    @IBOutlet weak var buttonBiometricBottomConstraint: NSLayoutConstraint!
    
    let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
    let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
    
    var viewModel: WalletLoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if KeyChainServiceWrapper.standard.loginWalletPassword == nil || !(viewModel?.isBiometricEnabled ?? false) {
            buttonBiometric.isHidden = true
        } else {
            buttonBiometric.isHidden = false
        }
        registerKeyboardNotifications()
        getPinCell()?.pinView.clearPin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel?.isBiometricEnabled ?? false {
            self.view.endEditing(true)
            loginWithBiometric()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotification()
    }
    
    override func leftButtonAction(button: UIButton) {
        var index = 0
        if let tabBarVC = self.tabBarController as? TabbarController {
            index = tabBarVC.previousSelectedTabBarIndex
        }
        RootViewControllerRouter.setTabbarAsRootVC(animated: false, initialVCIndex: index)
    }
    
    override func setupViewModel() {
        viewModel = WalletLoginViewModel()
        viewModel?.delegate = self
    }
    
    func setupUi() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        registerNib()
        showScreenTitleWithLeftBarButton()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        buttonBiometric.setButtonConfig(btnConfig: viewModel?.buttonUseBiometricsConfig)
    }
    
    private func registerNib() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PinEnteryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PinEnteryTableViewCell")
    }
    
    // MARK: - Keyboard Handling
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHide, object: nil)
    }
    
    @objc  func keyboardWillShow(_ notification: Notification?) {
        
        //  Getting UIKeyboardSize.
        if let info = notification?.userInfo, let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            buttonBiometricBottomConstraint.constant = kbFrame.size.height
        }
    }
    
    @objc  func keyboardWillHide(_ notification: Notification?) {
        buttonBiometricBottomConstraint.constant = 30
    }
    
    // MARK: - Pin Handling And Get Pin Cell
    
    func didPinEnteredVC(pin: String) {
        viewModel?.validateMPin(request: MpinRequest(mpin: pin))
    }
    private func getPinCell() -> PinEnteryTableViewCell? {
        return tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PinEnteryTableViewCell
    }
    
    // MARK: - Button Actions
    
    @objc func forgotButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        navigateToForgotPin()
        
    }
    
    @IBAction func buttonBiometricAction(_ sender: UIButton) {
        self.view.endEditing(true)
        loginWithBiometric()
    }
    
    func loginWithBiometric() {
        LAContext.authenticationWithBiometric(fallbackTitle: localizedStringForKey(key: "biometrics_reason"), viewController: self, completion: { result in
            DispatchQueue.main.async {
                if result {
                    UserDefaults.standard.isWalletBiometricEnabled = true
                    if let pin = KeyChainServiceWrapper.standard.loginWalletPassword {
                        self.view.endEditing(true)
                        self.viewModel?.validateMPin(request: MpinRequest(mpin: pin))
                    } else {
                        CommonAlertHandler.showErrorResponseAlert(for: "Sometthing went wrong need to login with pin")
                        self.getPinCell()?.pinView.clearPin()
                    }
                    
                } else {
                    CommonAlertHandler.showErrorResponseAlert(for: localizedStringForKey(key: "biometrics_auth_failure_msg"))
                    self.getPinCell()?.pinView.clearPin()
                }
            }
        })
    }
}

// MARK: - WalletLoginDataPassignDelegate
extension WalletLoginViewController: WalletLoginDataPassignDelegate {
    
    func validateMpinFailureHandler(message: String) {
        let cell = getPinCell()
        cell?.lableShowError.isHidden = false
        cell?.pinView.clearPin()
        if message == "Invalid Mpin" {
            cell?.lableShowError.text = localizedStringForKey(key: "pin.invalid.pin.title")
        } else {
            cell?.lableShowError.text = message
        }
    }
    
    func validateMpinSuccessHandler() {
        popToDashboard()
    }
}

// MARK: - UITableViewDataSource
extension WalletLoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PinEnteryTableViewCell", for: indexPath) as? PinEnteryTableViewCell {
            let config = PinEnteryTableViewCellConfig(
                strlabelTitle: localizedStringForKey(key: "wallet.login.pin.title"),
                strLableShowError: localizedStringForKey(key: "wallet.login.incorrect.pin.meesage"),
                strBtn: localizedStringForKey(key: "button.title.forgot_your_pin"))
         
            cell.labelTitle.textAlignment = .center
            cell.buttonResend.addTarget(self, action: #selector(forgotButtonAction(_:)), for: .touchUpInside)
            cell.lableShowError.isHidden = true
            cell.configureCell(config: config)
            cell.buttonResendTopConstraint.constant = 0
            cell.selectionStyle = .none
            cell.didPinEntered = didPinEnteredVC(pin:)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Navigation
extension  WalletLoginViewController {
    private func navigateToForgotPin() {
        let model = AcceptMobileNumberModel(title: localizedStringForKey(key: "forgot.pin.title"), desc: localizedStringForKey(key: "forgot.pin.desc"), buttonText: localizedStringForKey(key: "button.title.continue"), endPoint: .forgotPin)
        let vc = AcceptMobileNumberViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.AcceptMobileNumberViewController)
        vc.viewModel.acceptMobileNumberModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func popToDashboard() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
