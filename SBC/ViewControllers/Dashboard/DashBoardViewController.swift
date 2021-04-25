import UIKit

class DashBoardViewController: BaseViewController {
    
    var viewModel: DashBoardViewModelProtocol?
    @IBOutlet var labelBalance: UILabel? {
        willSet {
            newValue?.text = localizedStringForKey(key: "dashboard.balance")
        }
    }
    
    @IBOutlet var labelBalanceValue: UILabel?
    var walletBalance: Double = 0.0
    
    @IBOutlet var buttonTopup: UIButton? {
        willSet {
            newValue?.setTitle(localizedStringForKey(key: "dashboard.action.topup"), for: .normal)
        }
    }
    
    @IBOutlet var buttonWithdraw: UIButton? {
        willSet {
            newValue?.setTitle(localizedStringForKey(key: "dashboard.action.withdraw"), for: .normal)
        }
    }
    var shouldCallGetWalletStatusAPI = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.IBViewTop.isHidden = true
        labelBalanceValue?.attributedText = .currencyFormat(from: walletBalance, currency: "SGD")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !shouldCallGetWalletStatusAPI {
            self.view.isHidden = false
            viewModel?.getCustomerWalletBalance()
        } else {
            CommonUtil.sharedInstance.showLoader()
            self.view.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldCallGetWalletStatusAPI {
            shouldCallGetWalletStatusAPI = false
            CommonUtil.sharedInstance.removeLoader()
            if let response = viewModel?.walletRegisterStatusResponse, response.isWalletRegistered {
                navigateToWalletLoginVC()
                return
            }
            viewModel?.callGetWalletStatus()
        }
    }
    
    override func setupViewModel() {
        viewModel = DashBoardViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func didTappedTopUpButton(_ sender: Any) {
        self.navigateToTopUpVc()
    }
    
    @IBAction func didTappedWithdrawButton(_ sender: Any) {
        self.navigateToWithdrawVc()
    }
    
    func navigateToHome() {
        RootViewControllerRouter.setHomeNavAsRootVC(animated: false)
    }
    
    @IBAction func manageWalletButtonAction(_ sender: UIButton) {
        navigateToManageWalletVC()
    }
    
    private func handleWalletNavigation(response: WalletRegisterStatusResponse) {
        if response.isWalletRegistered {
            navigateToWalletLoginVC()
        } else if !response.isMobileVerified {
            navigateToWalletRegistrationVC()
        } else if !response.isPinSet {
            navigateToEnterPin()
        } else if let _ = response.customerHashId, let  _ = response.walletHashId {
            viewModel?.getCustomerData(customerHasId: response.customerHashId ?? "")
        } else if response.customerHashId == nil || response.walletHashId == nil {
            navigateToTOC()
        }
    }
}

// MARK: - DashBoardDataPassingDelegate

extension DashBoardViewController: DashBoardDataPassingDelegate {
    func getWalletBalanceSucces(response: WalletBalanceResponseArray) {
        //TODO: set the value
        let sgdArr = response.filter { (walletBalance) -> Bool in
            walletBalance.curSymbol == "SGD"
        }
        self.walletBalance = sgdArr.first?.balance ?? 0.0
        let currency = sgdArr.first?.curSymbol
        labelBalanceValue?.attributedText = .currencyFormat(from: walletBalance, currency: currency ?? "SGD")
    }
    func topUpSucces(response: TopUpRequestResponse) {
        navigateToQrTopUP(response: response)
    }
    func topUpFailure(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func getCustomerDataSucces(response: Customer) {
        if let tocFlag = response.termsAndConditionAcceptanceFlag, !tocFlag {
            navigateToTOC()
        } else if let complianceStatus = response.complianceStatus {
            if  complianceStatus.lowercased() != "COMPLETED".lowercased() {
                navigateToMyInfo(customer: response)
            } else {
                navigateToMyInfoDetailsVC(customer: response)
            }
        }
    }
    
    func getCustomerDataFailure(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func showWalletBalance(amount: Double, currency: String) {
        labelBalanceValue?.attributedText = .currencyFormat(from: amount, currency: currency)
    }
    
    func updateLoadingStatus(isLoading: Bool) {
        if isLoading {
            CommonUtil.sharedInstance.showLoader()
        } else {
            CommonUtil.sharedInstance.removeLoader()
        }
    }
    
    func succesWalletStatus(response: WalletRegisterStatusResponse) {
        handleWalletNavigation(response: response)
    }
    
    func failureWithError(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
}

// MARK: - Navigation

extension DashBoardViewController {
    
    func navigateToWalletRegistrationVC() {
        let vc = AcceptMobileNumberViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.AcceptMobileNumberViewController)
        vc.viewModel.acceptMobileNumberModel = AcceptMobileNumberModel(title: localizedStringForKey(key: "MOBILE_NUMBER"), desc: localizedStringForKey(key: "WALLET_REGISTARTION_DESCRIPTION"), buttonText: localizedStringForKey(key: "NEXT"), endPoint: .registerWallet)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWalletLoginVC() {
        let vc = WalletLoginViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletLogin, storyboardId: StoryboardId.WalletLoginViewController)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEnterPin() {
        let vc = EnterPinViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.EnterPinViewController)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToBiometric(response: WalletRegisterStatusResponse) {
        let vc = BiometricsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Biometrics, storyboardId: StoryboardId.BiometricsViewController)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTopUpVc() {
        let vc = TopUpAmountViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TopUp, storyboardId: StoryboardId.TopUpAmountViewController)
        vc.viewModel?.getBalanceAmount = self.walletBalance
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWithdrawVc() {
        let vc = WithdrawAmountViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Withdraw, storyboardId: StoryboardId.WithdrawAmountViewController)
        vc.viewModel?.getBalanceAmount = self.walletBalance
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTOC() {
        let vc = TnCViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TnCViewController)
        vc.viewModel?.isWalletTnC = true
        vc.viewModel?.redirectUrl = nil
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToMyInfo(customer: Customer) {
        let vc = MyInfoViewController.instantiateFromStoryboard(storyboardName: StoryboardName.MyInfo, storyboardId: StoryboardId.MyInfoViewController)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMyInfoDetailsVC(customer: Customer) {
        let vc = MyInfoDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.MyInfo, storyboardId: StoryboardId.MyInfoDetailsViewController)
        vc.viewModel?.dataModel = MyInfoDetailsModel(dob: customer.dateOfBirth, name: customer.fullName, address: customer.fullBillingAddress)
        vc.viewModel?.customerDetails = customer
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToQrTopUP(response: TopUpRequestResponse) {
        let vc = TopUpQRCodeViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TopUp, storyboardId: StoryboardId.TopUpQRCodeViewController)
        vc.viewModel?.topUPQrResponse = response
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToManageWalletVC() {
        let vc = ManageWalletViewController.instantiateFromStoryboard(storyboardName: StoryboardName.ManageWallet, storyboardId: StoryboardId.ManageWalletViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
