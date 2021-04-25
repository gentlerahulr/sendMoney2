//
//  TransactionDetailViewController.swift
//  SBC
//

import Foundation
import UIKit
import JVFloatLabeledTextField
import IQKeyboardManagerSwift

class PaymentDetailViewController: BaseViewController {

    @IBOutlet weak var textFieldCVV: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorCVV: UILabel!
    @IBOutlet weak var viewCVV: UIView!
    
    @IBOutlet weak var tooltipContainerView: UIView!
    @IBOutlet weak var viewDetailTopUp: UIView!
    @IBOutlet weak var labelTooltipCVV: UILabel!
    
    @IBOutlet weak var labelTitleOne: UILabel!
    @IBOutlet weak var labelValueOne: UILabel!
    
    @IBOutlet weak var labelTitleTwo: UILabel!
    @IBOutlet weak var labelValueTwo: UILabel!
    
    @IBOutlet weak var labelTitleThree: UILabel!
    @IBOutlet weak var labelValueThree: UILabel!
    
    @IBOutlet weak var labelConfirmDesc: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomStackViewBottomConstraint: NSLayoutConstraint!
    
    let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
    let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
    
    var viewModel: PaymentDetailViewModelProtocol?
    var transactionType: TransactionType?
    
    let defaultKeyboardDistanceFromTextField = IQKeyboardManager.shared.keyboardDistanceFromTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
        guard self.viewModel?.topupRequest?.method == .card else {
            return
        }
        IQKeyboardManager.shared.enableAutoToolbar = true
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard self.viewModel?.topupRequest?.method == .card else {
            return
        }
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = defaultKeyboardDistanceFromTextField
        removeKeyboardNotification()
    }
    
    override func setupViewModel() {
        viewModel = PaymentDetailViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUI() {
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(
                                            key: self.transactionType == .topup ? "top.up.screen.title" : "withdraw.screen.title"),
                                         leftButtonImage: ImageConstants.IMG_BACK_WHITE,
                                         screenTitleFont: .boldFontWithSize(size: 14),
                                         screenTitleColor: colorConfig.navigation_header_color,
                                         headerBGColor: .themeDarkBlue)
        
        self.labelConfirmDesc.text = localizedStringForKey(key: self.transactionType == .withdraw ? "WITHDRAW_BOTTOM_DESC" : (self.viewModel?.topupRequest?.method == .pay_now ? "PAY_NOW_BOTTOM_DESC" : "CARD_BOTTOM_DESC"))
        
        self.labelValueOne.text = "S$" + (self.transactionType == .topup ? (self.viewModel?.topupRequest?.amount ?? 0) :
            (self.viewModel?.withdrawRequest?.amount ?? 0)
        ).getDecimalGroupedAmount()
        self.labelTitleOne.text = "Amount"
        
        configurePaymentDetailsUI()
    }
    
    func configurePaymentDetailsUI() {
        if self.transactionType == .topup {
            guard self.viewModel?.topupRequest?.method == .card else {
                self.labelTitleTwo.text = "Top up method"
                self.labelValueTwo.text = "Paynow"
                self.viewDetailTopUp.isHidden = true
                return
            }
            
            if let card = self.viewModel?.topupRequest?.source {
                self.viewDetailTopUp.isHidden = false
                
                self.labelTitleTwo.text = "Top up method"
                self.labelValueTwo.text = "Card"
                self.labelTitleThree.text = localizedStringForKey(key: "card.number")
                self.labelValueThree.text = card.maskCardNumber?.getHiddenCardNumber()
                self.configureTextField()
                self.updateConfirmButtonState(to: false)
                self.textFieldCVV.becomeFirstResponder()
            }
        }
    }
    private func configureTextField() {
        textFieldCVV?.floatingLabel.textColor = .themeDarkBlueTint1
        textFieldCVV?.keyboardType = .numberPad
        textFieldCVV?.floatingLabelXPadding = 0
        textFieldCVV?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textFieldCVV?.delegate = self
        textFieldCVV?.floatingLabel.font = .regularFontWithSize(size: 13)
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
            labelConfirmDesc.isHidden = true
            bottomStackViewBottomConstraint.constant = kbFrame.size.height + 20
        }
    }
    
    @objc  func keyboardWillHide(_ notification: Notification?) {
        labelConfirmDesc.isHidden = false
        bottomStackViewBottomConstraint.constant = 30
    }
    
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        textField.reformatAsCVV()
        if textField.getText().count == 3 {
            self.view.endEditing(true)
        }
    }
    
    private func updateConfirmButtonState(to active: Bool) {
        submitButton.isEnabled = active
        submitButton.backgroundColor = getSubmitButtonColor(active: active)
    }
    
    private func getSubmitButtonColor(active: Bool) -> UIColor {
        if active {
            return .themeDarkBlue
        } else {
            return .themeDarkBlueTint2
        }
    }
    
    @IBAction private func Info_Tapped(_ sender: UIButton) {
        tooltipContainerView.isHidden = !tooltipContainerView.isHidden
    }
    
    @IBAction private func Confirm_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let request = self.viewModel?.withdrawRequest  else {
            let amount = "\(self.viewModel?.topupRequest?.amount ?? 0)"
            if let topupRequest = self.viewModel?.topupRequest, let card = topupRequest.source, topupRequest.method == .card {
                guard let cvv = (self.textFieldCVV.text as NSString?)?.integerValue else {
                    CommonAlertHandler.showErrorResponseAlert(for: "Enable to proceed getting cvv as null.")
                    return
                }
                let request = TopUpCardRequest(amount: amount, fundingInstrumentId: card.fundingInstrumentID ?? "",
                                               fundingInstrumentHolderName: card.cardHolderName,
                                               fundingInstrumentSecurityNumber: "\(cvv)".toBase64(), fundingInstrumentNumber: nil,
                                               fundingInstrumentExpiry: nil, save: true)
                self.viewModel?.performAddPaymentFromCard(request: request)
                return
            }
            let request = TopUpFromPayNowRequest(fundingChannel: "bank_transfer", amount: amount, pocketName: "", sourceCurrencyCode: "SGD", destinationCurrencyCode: "SGD")
            viewModel?.performTopUpFromPayNow(request: request)
            return
        }
        viewModel?.getExchangeRate()
    }
    
}

extension PaymentDetailViewController: PaymentDetailPassingDelegate {
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
    
    func addCardSuccess(response: TopUpCardFundResponse) {
        navigateToStripeVC(response: response)
    }
    func topUpSucces(response: TopUpRequestResponse) {
        navigateToQrTopUP(response: response)
    }
    
    func topUpFailure(message: String) {
        navigateToOOPS()
    }
}

extension PaymentDetailViewController {
    func navigateToQrTopUP(response: TopUpRequestResponse) {
        let vc = TopUpQRCodeViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TopUp, storyboardId: StoryboardId.TopUpQRCodeViewController)
        vc.viewModel?.topUPQrResponse = response
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Navigation
extension PaymentDetailViewController {
    func navigateToStripeVC(response: TopUpCardFundResponse? = nil) {
        let vc = StripeUIWebviewViewController.instantiateFromStoryboard(storyboardName: StoryboardName.StripeWebView, storyboardId: StoryboardId.StripeUIWebviewViewController)
        vc.viewModel?.topUpCardFundResponse = response
        vc.viewModel?.redirectURL = response?.returnUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToOOPS() {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.Oops,
                                       title: localizedStringForKey(key: "transaction.failure.card"),
                                       desc: "", contact: "",
                                       btnTitle: localizedStringForKey(key: "button.title.topUP"),
                                       backgroundColor: ColorHex.ThemeRed)
        vc.viewModel?.dataModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSuccessTransaction () {
        let vc = NotificationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification,
                                                                      storyboardId: StoryboardId.NotificationCustomViewController)
        let model  = NotificationModel(imageName: ImageConstants.SuccessTopUp, title: localizedStringForKey(key: "withdraw.success.message"), desc: "", contact: "",
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

// MARK: TextField Delegate
extension PaymentDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        labelErrorCVV.isHidden = true
        viewCVV.backgroundColor = .themeNeonBlue
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = defaultKeyboardDistanceFromTextField
        if textFieldCVV.getText().count != 3 {
            labelErrorCVV.isHidden = false
            updateConfirmButtonState(to: false)
        }
        viewCVV.backgroundColor = .themeDarkBlue
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            if self.textFieldCVV.getText().length() == 3 {
                self.updateConfirmButtonState(to: true)
            } else {
                self.updateConfirmButtonState(to: false)
            }
        }
        return true
    }
}
