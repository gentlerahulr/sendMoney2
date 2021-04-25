//
//  CreateNewPasswordExtension+TableView.swift
//  SBC
//

import Foundation
import UIKit

extension CreateNewPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.viewModel.arrayOfCells[indexPath.row]
        
        switch cellType {
            
        case .cellTittle:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TittleWithDescriptionTableViewCell
            cell.strTittle = localizedStringForKey(key: "CREATE_NEW_PASSWORD")
            cell.configureEmailCell()
            return cell
        case .cellPassword:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! TextfieldTableViewCell
            cell.backgroundColor = UIColor.clear
            
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = localizedStringForKey(key: "ENTER_NEW_PASSWORD_MESSAGE")
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            cell.textfield.textfield.text = viewModel.password
            cell.contentView.backgroundColor = .clear
            txtPassword = cell.textfield
            txtPassword?.textfield.isSecureTextEntry = true
            txtPassword?.textfield.clearsOnBeginEditing = false
            txtPassword?.textfield.tag = TextFieldTag.password.rawValue
            switch self.viewModel.validationStatePassword {
            case .valid:
                break
            case .inValid(let error):
                txtPassword.setState(state: CustomTextfieldView.FieldState.error)
                txtPassword.configureError(error: error)
                break
            }
            self.setUpShowPasswordPanel()
            self.addActionsForPasswordField(txtPassword: cell.textfield)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
            
        case .cellConfirmPassword:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmPasswordCell", for: indexPath) as! TextfieldTableViewCell
            cell.backgroundColor = UIColor.clear
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = localizedStringForKey(key: "CONFIRM_PASSWORD")
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            cell.textfield.textfield.text = viewModel.confirmPassword
            cell.contentView.backgroundColor = UIColor.clear
            txtConfirmPassword = cell.textfield
            txtConfirmPassword?.textfield.isSecureTextEntry = true
            txtConfirmPassword?.textfield.clearsOnBeginEditing = false
            txtConfirmPassword?.textfield.tag = TextFieldTag.password.rawValue
            switch self.viewModel.validationStateConfirmPassword {
                
            case .valid:
                break
            case .inValid(let error):
                txtConfirmPassword.setState(state: CustomTextfieldView.FieldState.error)
                txtConfirmPassword.configureError(error: error)
                break
            }
            self.setUpShowConfirmPasswordPanel()
            self.addActionsForConfirmPasswordField(txtConfirmPassword: cell.textfield)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        case .cellValidation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ValidationCell", for: indexPath) as! TittleWithDescriptionTableViewCell
            cell.configureValidationRuleCell()
            return cell
        case .cellSubmitBtn:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell  else {
                fatalError("The dequeued cell is not an instance of MWRButtonTableViewCell.")
            }
            if self.btnUpadte == nil {
                self.btnUpadte = cell.btnAction
                self.btnUpadte.isEnabled = false
            }
            
            if self.btnUpadte.isEnabled {
                let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 30, left: 20, bottom: 10, right: 20),
                                                                 buttonBackgroundColor: UIColor(colorConfig.primary_button_color!)!,
                                                                 buttonTextColor: UIColor.white,
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
            let title = localizedStringForKey(key: "UPDATE_PASSWORD")
            cell.configure(title: title)
            cell.btnAction.titleLabel?.text = title
            self.btnUpadte = cell.btnAction
            cell.btnAction.addTarget(self, action: #selector(didTappedUpdatePasswordButtonAction(_ :)), for: UIControl.Event.touchUpInside)
            cell.configure(title: title)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        default:
            return UITableViewCell()
        }
    }
}
