//
//  SavedItemCell.swift
//  SBC
//

import UIKit
import JVFloatLabeledTextField

protocol SavedItemViewDelegate: AnyObject {
    func savedItem(didDeletedAt row: Int, view: SavedItemCell)
    func SavedItem(didSelect item: BankCard?, view: SavedItemCell)
    func SavedItem(didSelect item: Beneficiary?, view: SavedItemCell)
    func SavedItemDidEditing(securityCode: Int?, isvalid: Bool, view: SavedItemCell)
}

class SavedItemCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var viewBase: UIView!
    
    @IBOutlet weak var textFieldCVV: JVFloatLabeledTextField!
    @IBOutlet weak var labelErrorCVV: UILabel!
    @IBOutlet weak var viewCVV: UIView!
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    weak var delegate: SavedItemViewDelegate?
    var transactionType: TransactionType!
    
    var bankCard: BankCard? {
        didSet {
            if let card = bankCard {
                self.labelTitle.text = card.cardNetwork?.capitalized
                self.labelInfo.text = card.maskCardNumber?.getHiddenCardNumber()
                self.buttonDelete.setTitle("Delete", for: .normal)
            } else {
                self.labelTitle.text = localizedStringForKey(key: "ADD_NEW_CARD")
                self.labelInfo.text = nil
                self.buttonDelete.setTitle(nil, for: .normal)
            }
        }
    }
    
    var bankAccount: Beneficiary? {
        didSet {
            if let account = bankAccount {
                self.labelTitle.text = account.payoutDetail.bankName
                self.labelInfo.text = account.payoutDetail.accountNumber?.getHiddenAccountNumber()
                self.buttonDelete.setTitle("Delete", for: .normal)
            } else {
                self.labelTitle.text = localizedStringForKey(key: "ADD_NEW_ACCOUNT")
                self.labelInfo.text = nil
                self.buttonDelete.setTitle(nil, for: .normal)
            }
         }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureTextField()
        labelInfo.textColor = .themeDarkBlueTint1
    }
    
    func configureTextField() {
        textFieldCVV.keyboardType = .numberPad
        textFieldCVV.delegate = self
        textFieldCVV.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textFieldCVV.floatingLabel.font = .regularFontWithSize(size: 13)
    }
    
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        textField.reformatAsCVV()
        guard let string = textField.text else {
            self.delegate?.SavedItemDidEditing(securityCode: nil, isvalid: false, view: self)
            return
        }
        let isValidateCode = string.count == 3
        self.delegate?.SavedItemDidEditing(securityCode: (isValidateCode ? (string as NSString).integerValue : nil), isvalid: isValidateCode, view: self)
        
    }
    
    @IBAction private func deleteTapped(_ sender: UIButton) {
        guard sender.title(for: .normal) != nil else {
            return
        }
        self.delegate?.savedItem(didDeletedAt: sender.tag, view: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.viewBase.setBorderWithColor(borderColor: (selected ? .themeDarkBlue : .themeDarkBlueTint3), borderWidth: 1.5, cornerRadius: 10)
    }
    
}

extension SavedItemCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelErrorCVV.isHidden = true
        viewCVV.backgroundColor = .themeNeonBlue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let string = textField.text else {
            labelErrorCVV.isHidden = false
            return
        }
        
        let isValidateCode = string.count == 3
        labelErrorCVV.isHidden = isValidateCode
        viewCVV.backgroundColor = .themeDarkBlue
    }
    
}
