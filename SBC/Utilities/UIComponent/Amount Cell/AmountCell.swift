//
//  AmountCell.swift
//  SBC

import UIKit
import JVFloatLabeledTextField

enum TransactionType: Int {
    case withdraw
    case topup
    case other
}

protocol AmountValidationDelegate: AnyObject {
    func amountDidEditing(_ isValid: Bool, amount: Float, formattedAmount: String?)
    func amountStartEditing()
    func amountEndEditing()
}

class AmountCell: UITableViewCell {
    
    @IBOutlet weak var textFieldAmount: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorAmount: UILabel!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var labelFixAmount: UILabel!
    
    weak var delegate: AmountValidationDelegate?
    
    var selectedBarItem: UIBarButtonItem?
    let staticAmountArray: [String] = UserDefaults.standard.appConfigurationValues?.staticValues ?? K.defaultStaticAmountArray
    var transactionType: TransactionType = .topup {
        didSet {
            switch transactionType {
            case .topup:
                self.configureTextfieldAccessory()
            default:
                debugPrint("No Action")
            }
        }
    }
    
    var balanceAmount: Double = K.defaultAmountDouble {
        didSet {
            
            self.labelFixAmount.text = "S$\(String(format: "%.2f", balanceAmount))"
            
        }
    }
    
    var targetAmount: Float = K.defaultAmountFloat
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUIInitialization()
    }
    
    func configureUIInitialization() {
        textFieldAmount.delegate = self
        textFieldAmount.floatingLabel.font = .regularFontWithSize(size: 13)
        textFieldAmount.text = K.defaultAmountString
        textFieldAmount.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textFieldAmount.alwaysShowFloatingLabel = true
        textFieldAmount.floatingLabel.text = "Amount"
    }
    
    func configureTextfieldAccessory() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .themeDarkBlue
        let width = self.frame.width/CGFloat(staticAmountArray.count)
        var barButtonItemArray = [UIBarButtonItem]()
        for (index, amount) in staticAmountArray.enumerated() {
            let barButtonItem = UIBarButtonItem(title: amount, style: .plain, target: self, action: #selector(textFieldToolBar(_:)))
            barButtonItem.tag = index
            barButtonItem.width = width
            let attributes = [NSAttributedString.Key.font: UIFont.boldFontWithSize(size: 13)]
            barButtonItem.setTitleTextAttributes(attributes, for: .normal)
            barButtonItem.setTitleTextAttributes(attributes, for: .highlighted)
            barButtonItemArray.append(barButtonItem)
        }
        toolBar.setItems(barButtonItemArray, animated: false)
        textFieldAmount.inputAccessoryView = toolBar
    }
    
    @objc func textFieldToolBar(_ sender: UIBarButtonItem) {
        var amount: Float = K.defaultAmountFloat
        guard var amountString = sender.title else {
            return
        }
        amountString = amountString.replacingOccurrences(of: "$", with: "")
        amountString = amountString.replacingOccurrences(of: "S", with: "")
        amount = Float(amountString) ?? K.defaultAmountFloat
        self.textFieldAmount.text = String(format: "%.2f", amount)
        self.labelErrorAmount.isHidden = true
        self.viewAmount.backgroundColor = .themeDarkBlue
        self.delegate?.amountDidEditing(true, amount: amount, formattedAmount: sender.title?.replacingOccurrences(of: "$S", with: ""))
        
        if let previousSelectedItem = self.selectedBarItem {
            previousSelectedItem.tintColor = .themeDarkBlue
        }
        
        sender.tintColor = .themeNeonBlue
        self.selectedBarItem = sender
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        selectedBarItem?.tintColor = .themeDarkBlue
        if textField.text?.isEmpty ?? true {
            self.delegate?.amountDidEditing(false, amount: K.defaultAmountFloat, formattedAmount: textField.text)
            return
        }
        let amount = textField.reformateAsFloatAmount(maximumFractionDigits: 2, onEndEditing: false)
        
        let transactionAmountStatus = CommonValidation.isValidTransactionAmount(amount, targetAmount: self.targetAmount)
        let isValidAmount = transactionAmountStatus == .valid ? true: false
        
        self.delegate?.amountDidEditing(isValidAmount, amount: amount, formattedAmount: textField.text)
        self.handleTransactionAmountStatus(status: transactionAmountStatus)
        
    }
    
}

extension AmountCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let amountStr = textField.text, amountStr == K.defaultAmountString {
            textField.text = ""
        }
        self.delegate?.amountStartEditing()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldString = textField.removeCommas()
        
        if oldString.contains(".") && string == "." {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let amount = textField.reformateAsFloatAmount(maximumFractionDigits: 2, onEndEditing: true)
        
        let transactionAmountStatus = CommonValidation.isValidTransactionAmount(amount, targetAmount: self.targetAmount)
        let isValidAmount = transactionAmountStatus == .valid ? true: false
        
        if amount == 0 {
            textField.text = K.defaultAmountString
        }
        self.delegate?.amountDidEditing(isValidAmount, amount: amount, formattedAmount: textField.text)
        self.delegate?.amountEndEditing()
        self.handleTransactionAmountStatus(status: transactionAmountStatus)
    }
    
    private func handleTransactionAmountStatus(status: TransactionAmountStatus) {
        
        if status == .valid {
            labelErrorAmount.isHidden = true
            viewAmount.backgroundColor = .themeDarkBlue
        } else {
            labelErrorAmount.isHidden = false
            viewAmount.backgroundColor = .themeRed
        }
        
        if status == .min_balance_error {
            labelErrorAmount.text = self.transactionType == .topup ?
                String(format: localizedStringForKey(key: "top.up.min.error.message"), Config.MIN_TOPUP_AMOUNT):
                String(format: localizedStringForKey(key: "withdraw.min.error.message"), Config.MIN_TOPUP_AMOUNT)
        } else if status == .max_balance_error {
            labelErrorAmount.text = self.transactionType == .topup ? localizedStringForKey(key: "top.up.max.error.message") : localizedStringForKey(key: "withdraw.balance.error.message")
        }
        
    }
    
}
