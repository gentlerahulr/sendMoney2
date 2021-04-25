//
//  PasswordRecoveryExtension+TableView.swift
//  SBC
//

import Foundation
import UIKit

extension PasswordRecoveryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.viewModel.arrayOfCells[indexPath.row]
        
        switch cellType {
            
        case .cellTittle:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "TittleCell", for: indexPath) as! TittleWithDescriptionTableViewCell
            cell.strTittle = localizedStringForKey(key: "PASSWORD_RECOVERY_TITTLE")
            cell.configurePasswordRecovryCell()
            return cell
        case .cellEmail:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! TextfieldTableViewCell
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = localizedStringForKey(key: "EMAIL_ADDRESS")
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            self.txtEmail = cell.textfield
            cell.textfield.textfield.text = viewModel.emailID
            txtEmail?.textfield.clearsOnBeginEditing = false
            txtEmail?.textfield.tag = TextFieldTag.email.rawValue
            cell.textfield.textfield.borderStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            self.addActionsForEmailAddress(txtEmail: cell.textfield)
            cell.textfield.textfield.keyboardType = UIKeyboardType.emailAddress
            switch viewModel.validationStateEmail {
            case .valid:
                break
            case .inValid(let error):
                txtEmail.setState(state: CustomTextfieldView.FieldState.error)
                txtEmail.configureError(error: error)
            }
            cell.selectionStyle = .none
            return cell
            
        case .cellProceddBtn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ButtonTableViewCell.")
            }
            if self.btnProceed == nil {
                self.btnProceed = cell.btnAction
                self.btnProceed.isEnabled = false
            }
            
            if self.btnProceed.isEnabled {
                let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 20, left: 20, bottom: 10, right: 20),
                                                                 buttonBackgroundColor: .themeDarkBlue, buttonTextColor: UIColor.white,
                                                                 buttonFont: AppManager.appStyle.font(for: .primaryActionButton),
                                                                 borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 8.0,
                                                                 enabledButton: true)
                cell.configureViewModel(model: vmForButton)
            } else {
                let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 30, left: 20, bottom: 10, right: 20),
                                                                 buttonBackgroundColor: .themeDarkBlueTint2,
                                                                 buttonTextColor: .themeDarkBlueTint1,
                                                                 buttonFont: .boldFontWithSize(size: 16),
                                                                 borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 8.0,
                                                                 enabledButton: false)
                cell.configureViewModel(model: vmForButton)
            }
            
            let title = localizedStringForKey(key: "NEXT")
            cell.btnAction.titleLabel?.text = title
            cell.btnAction.addTarget(self, action: #selector(didTappedNextButtonAction(_ :)), for: UIControl.Event.touchUpInside)
            cell.configure(title: title)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        default:
            return UITableViewCell()
        }
    }
}
