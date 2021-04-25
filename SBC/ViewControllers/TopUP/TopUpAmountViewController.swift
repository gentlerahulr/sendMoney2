//
//  TopUpAmountViewController.swift
//  SBC
//

import UIKit
import JVFloatLabeledTextField
import IQKeyboardManagerSwift

enum TopUpMethod: Int {
    case card = 0
    case pay_now = 1
}

class TopUpAmountViewController: BaseViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var enteredAmount: Float = 00.00
    var shouldAddNewSource = true
    var isAmountEditing = true
    var viewModel: TopUpViewModelProtocol?
    var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUIInitialization()
        self.configureTableView()
        self.showKeyboardForAmount()
        self.updateCardList()
        self.viewModel?.fetchSavedCards()
    }
    
    override func setupViewModel() {
        viewModel = TopUpViewModel()
        viewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if (selectedCellIndexPath?.row ?? 0) >= (self.viewModel?.savedItems.count ?? 0) {
            return
        }
        self.viewModel?.securityCode = nil
        self.viewModel?.selectedSource = nil
        if let indexPath = selectedCellIndexPath {
            tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .themeDarkBlueTint2
        }
        selectedCellIndexPath = nil
        self.updateCardList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureTableView() {
        
        let amountCellNib = UINib(nibName: "AmountCell", bundle: nil)
        let savedItemNib = UINib(nibName: "SavedItemCell", bundle: nil)
        let topUpMethodNib = UINib(nibName: "TopUpMethodCell", bundle: nil)
        self.tableView.register(amountCellNib, forCellReuseIdentifier: "AmountCell")
        self.tableView.register(savedItemNib, forCellReuseIdentifier: "SavedItemCell")
        self.tableView.register(topUpMethodNib, forCellReuseIdentifier: "TopUpMethodCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .white
    }
    
    func configureUIInitialization() {
        
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(.themeLightBlue, for: .disabled)
        nextButton.isEnabled = false
        nextButton.backgroundColor = .themeDarkBlueTint2
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(key: "top.up.screen.title"),
                                         leftButtonImage: ImageConstants.IMG_BACK_WHITE,
                                         screenTitleFont: .boldFontWithSize(size: 14),
                                         screenTitleColor: colorConfig.navigation_header_color, headerBGColor: .themeDarkBlue)
    }
    
    func numberOfRowsForSavedCards() -> Int {
        return (self.isAmountEditing || self.viewModel?.selectedMethod == .pay_now) ? 0 : ((self.viewModel?.savedItems.count ?? 0) > 0 ? (self.viewModel?.savedItems.count ?? 0)+1 : 0)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButtonBC.constant <= 25 {
                self.nextButtonBC.constant = keyboardSize.height + 25
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButtonBC.constant > 25 {
                self.nextButtonBC.constant = 25
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction private func Next_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.viewModel?.selectedMethod == .pay_now || self.viewModel?.selectedSource != nil {
            let vc = PaymentDetailViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Common, storyboardId: StoryboardId.PaymentDetailViewController)
            vc.viewModel?.topupRequest = self.viewModel?.topupRequest
            vc.transactionType = .topup
            if viewModel?.selectedMethod == .pay_now {
                selectedCellIndexPath = nil
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = CardPaymentViewController.instantiateFromStoryboard(storyboardName: StoryboardName.CardPayment, storyboardId: StoryboardId.CardPaymentViewController)
            vc.viewModel?.request = self.viewModel?.topupRequest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showActionPopup(parentView: UIView) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "ARE_YOU_SURE"),
                                              descText: localizedStringForKey(key: "REMOVE_CARD_DESC"),
                                              positiveButtonText: localizedStringForKey(key: "REMOVE_CARD"),
                                              negativeButtonText: localizedStringForKey(key: "CANCEL"))
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeRed, hideNegativeButton: false, style: .bottomSheet)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        parentView.addSubview(actionPopupView)
    }
    
    func setNextButtonEnabled(isEnabled: Bool) {
        self.nextButton.isEnabled = isEnabled
    }
    
    func updateNextButton() {
        
        if self.enteredAmount == K.defaultAmountFloat {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .themeDarkBlueTint2
        } else {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .themeDarkBlue
        }
    }
    
    func showKeyboardForAmount() {
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AmountCell {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
                cell.textFieldAmount.becomeFirstResponder()
            }
        }
    }
    
    func updateCardList() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 2), with: .fade)
            
            guard self.numberOfRowsForSavedCards() > 0 else {
                return
            }
            
            guard let item = self.viewModel?.selectedSource else {
                let indexPath = IndexPath(row: self.viewModel?.savedItems.count ?? 0, section: 2)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                self.updateNextButton()
                return
            }
            if let index = self.viewModel?.savedItems.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: 2)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                self.updateNextButton()
            }
        }
    }
}

extension TopUpAmountViewController: TopUpPassingDelegate {
    func showSavedCards(response: SavedCardResponse) {
        self.updateCardList()
    }
}

extension TopUpAmountViewController: SavedItemViewDelegate, TopUpMethodDelegate {
    
    func SavedItemDidEditing(securityCode: Int?, isvalid: Bool, view: SavedItemCell) {
        self.viewModel?.securityCode = securityCode
        self.updateNextButton()
    }
    
    func topUpMethod(didSelect method: TopUpMethod, view: TopUpMethodCell) {
        self.viewModel?.selectedMethod = method
        self.updateCardList()
        self.updateNextButton()
    }
    
    func savedItem(didDeletedAt row: Int, view: SavedItemCell) {
        self.showActionPopup(parentView: self.view)
    }
    
    func SavedItem(didSelect item: BankCard?, view: SavedItemCell) {
        self.shouldAddNewSource = item == nil
        self.viewModel?.selectedSource = item
    }
    
    func SavedItem(didSelect item: Beneficiary?, view: SavedItemCell) {
    
    }
}

extension TopUpAmountViewController: AmountValidationDelegate {
    
    func amountStartEditing() {
        self.isAmountEditing = true
        self.updateCardList()
    }
    
    func amountEndEditing() {
        self.isAmountEditing = false
        self.updateCardList()
    }
    
    func amountDidEditing(_ isValid: Bool, amount: Float, formattedAmount: String?) {
        DispatchQueue.main.async {
            if isValid {
                self.viewModel?.amount = amount
                self.viewModel?.formattedAmount = formattedAmount
                self.enteredAmount = amount
            } else {
                self.enteredAmount = K.defaultAmountFloat
            }
            self.updateNextButton()
        }
    }
}
