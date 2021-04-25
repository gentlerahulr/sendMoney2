//
//  WithDrawConfirmationViewController.swift
//  SBC


import UIKit

class WithDrawConfirmationViewController: BaseViewController {

    @IBOutlet weak var labelAmountValue: UILabel!
    @IBOutlet weak var labelWithDarawType: UILabel!
    @IBOutlet weak var labelAccountType: UILabel!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelSwiftCodeValue: UILabel!
    @IBOutlet weak var labelAccNo: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelConfirmDesc: UILabel!
    
    var viewModel: WithDrawConfirmationViewModelProtocol?
    var transactionType: TransactionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
}
    
    override func setupViewModel() {
        viewModel = WithDrawConfirmationViewModel()
        viewModel?.delegate = self
    }
    
    func configureUI() {
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(
                                            key: "withdraw.screen.title"),
                                         leftButtonImage: ImageConstants.IMG_BACK_WHITE,
                                         screenTitleFont: .boldFontWithSize(size: 14),
                                         screenTitleColor: colorConfig.navigation_header_color,
                                         headerBGColor: .themeDarkBlue)
        
        self.labelConfirmDesc.text = localizedStringForKey(key: "WITHDRAW_BOTTOM_DESC")
        self.labelAmountValue.text = "S$" + (self.viewModel?.withdrawRequest?.amount ?? 0).getDecimalGroupedAmount()
        self.labelWithDarawType.text = localizedStringForKey(key: "BANK_ACC")
        self.labelAccountType.text = self.viewModel?.withdrawRequest?.source?.payoutDetail.accountType
        self.labelFullName.text = self.viewModel?.withdrawRequest?.source?.beneficiaryDetail.name
        self.labelBankName.text =  self.viewModel?.withdrawRequest?.source?.payoutDetail.bankName
        self.labelAccNo.text = self.viewModel?.withdrawRequest?.source?.payoutDetail.accountNumber
        self.labelSwiftCodeValue.text = self.viewModel?.withdrawRequest?.source?.payoutDetail.routingCodeValue1
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func Confirm_Tapped(_ sender: UIButton) {
        viewModel?.getExchangeRate()
    }
    
}

extension WithDrawConfirmationViewController: WithDrawConfirmationPassingDelegate {
    func transfermoneySucces(response: TransferMoneyResponse) {
        navigateToSuccessTransaction()
    }
    
    func transfermoneyfailure(message: String) {
        navigateToFailureTrasanction()
    }
    
    func exchangeRateSucces(response: ExchangeRateResponse) {
        
        DispatchQueue.main.async { [self] in
            if let request = self.viewModel?.withdrawRequest {
                let amount = String(request.amount)
                let payOutRequest = PayoutRequest(audit_id: response.auditID, payout_id: request.source?.payoutDetail.payoutHashID ?? "", source_amount: amount)
                let beneRequest = BeneficiaryRequest(id: request.source?.beneficiaryDetail.beneficiaryHashID ?? "")
                let request_ = TransferMoneyRequest(beneficiary: beneRequest, payout: payOutRequest)
                self.viewModel?.transferMoney(request: request_)
            }
        }
       
    }
    
    func failure(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
}

// MARK: Navigation
extension WithDrawConfirmationViewController {
    func navigateToSuccessTransaction () {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.SuccessWithdraw, title: localizedStringForKey(key: "withdraw.success.message"), desc: "", contact: "",
                                       btnTitle: localizedStringForKey(key: "button.title.back_to_wallet"),
                                       backgroundColor: ColorHex.ThemeNeonBlue)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToFailureTrasanction() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.Oops, title: localizedStringForKey(key: "transaction.failure.card"),
                                       desc: "", contact: "", btnTitle: localizedStringForKey(key: "button.title.withdraw"),
                                       backgroundColor: ColorHex.ThemeRed)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
