//
//  WithdrawAmountViewController.swift
//  SBC
//

import UIKit

class WithdrawAmountViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBC: NSLayoutConstraint!
    
    var enteredAmount: Float = 00.00
    var isAmountEditing = true
    var viewModel: WithdrawViewModelProtocol?
    var selectedCellIndexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIInitialization()
        configureTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.showKeyboardForAmount()
        self.updateBeneFiciaryList()
        self.viewModel?.fetchSavedBeneficiaryList()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.updateBeneFiciaryList()
    }
    override func setupViewModel() {
        viewModel = WithdrawViewModel()
        viewModel?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUIInitialization() {
        
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeLightBlue, alpha: 1.0), for: .disabled)
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint2, alpha: 1.0)
        
        showScreenTitleWithLeftBarButton(screenTitle: "Withdraw funds", leftButtonImage: ImageConstants.IMG_BACK_WHITE, screenTitleFont: .boldFontWithSize(size: 14), screenTitleColor: colorConfig.navigation_header_color, headerBGColor: .themeDarkBlue)
    }
    
    func configureTableView() {
        
        let amountCellNib = UINib(nibName: "AmountCell", bundle: nil)
        let savedItemCellNib = UINib(nibName: "SavedItemCell", bundle: nil)
        self.tableView.register(amountCellNib, forCellReuseIdentifier: "AmountCell")
        self.tableView.register(savedItemCellNib, forCellReuseIdentifier: "SavedItemCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButtonBC.constant == 20 {
                self.nextButtonBC.constant = keyboardSize.height + 10
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.updateBeneFiciaryList()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButtonBC.constant > 20 {
                self.nextButtonBC.constant = 20
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.updateBeneFiciaryList()
                }
            }
        }
    }
    
    @IBAction private func Next_DidTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.viewModel?.selectedSource != nil {
            let vc = WithDrawConfirmationViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Common, storyboardId: StoryboardId.WithDrawConfirmationViewController)
            vc.viewModel?.withdrawRequest = self.viewModel?.withdrawRequest

            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = BankAccountViewController.instantiateFromStoryboard(storyboardName: StoryboardName.BankAccount, storyboardId: StoryboardId.BankAccountViewController)
            vc.viewModel?.request = self.viewModel?.withdrawRequest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfRowsForSavedBeneficiary() -> Int {
        return  ((self.viewModel?.savedItems.count ?? 0) > 0 ? (self.viewModel?.savedItems.count ?? 0)+1 : 0)
    }
    
    private func showActionPopup(parentView: UIView) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "ARE_YOU_SURE"),
                                              descText: localizedStringForKey(key: "REMOVE_BANK_DESC"),
                                              positiveButtonText: localizedStringForKey(key: "REMOVE_BANK"),
                                              negativeButtonText: localizedStringForKey(key: "CANCEL"))
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeRed, hideNegativeButton: false, style: .bottomSheet)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        
        actionPopupView.addPositiveButtonAction = {
            debugPrint("Callback For delete bank")
        }
        parentView.addSubview(actionPopupView)
    }
    
    func setNextButtonEnabled(isEnabled: Bool) {
        self.nextButton.isEnabled = isEnabled
        self.nextButton.backgroundColor = isEnabled ? .themeDarkBlue : .themeDarkBlueTint2
    }
    
    func showKeyboardForAmount() {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AmountCell {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
                cell.textFieldAmount.becomeFirstResponder()
            }
        }
    }
    
    func updateBeneFiciaryList() {
        DispatchQueue.main.async {
            guard let item = self.viewModel?.selectedSource else {
                let indexPath = IndexPath(row: self.viewModel?.savedItems.count ?? 0, section: 1)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                return
            }
            if let index = self.viewModel?.savedItems.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: 1)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
}

extension WithdrawAmountViewController: WithdrawPassingDelegate {
    func showSavedBeneficiary(response: SavedBeneficiaryResponse) {
        self.updateBeneFiciaryList()
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

extension WithdrawAmountViewController: SavedItemViewDelegate {
    func SavedItemDidEditing(securityCode: Int?, isvalid: Bool, view: SavedItemCell) {
        
    }
    
    func savedItem(didDeletedAt row: Int, view: SavedItemCell) {
        self.showActionPopup(parentView: self.view)
    }
    
    func SavedItem(didSelect item: BankCard?, view: SavedItemCell) {
        
    }
    
    func SavedItem(didSelect item: Beneficiary?, view: SavedItemCell) {
        self.viewModel?.selectedSource = item
    }
    
}

extension WithdrawAmountViewController: AmountValidationDelegate {
    func amountStartEditing() {
        self.isAmountEditing = true
        self.updateBeneFiciaryList()
    }
    
    func amountEndEditing() {
        self.isAmountEditing = false
        self.updateBeneFiciaryList()
    }
    
    func amountDidEditing(_ isValid: Bool, amount: Float, formattedAmount: String?) {
        DispatchQueue.main.async {
            self.viewModel?.amount = amount
            self.viewModel?.formattedAmount = formattedAmount
            self.setNextButtonEnabled(isEnabled: isValid)
        }
    }
}
