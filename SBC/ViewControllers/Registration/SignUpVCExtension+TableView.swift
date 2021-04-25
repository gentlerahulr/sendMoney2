//
//  SignUpVCExtension+TableView.swift
//  SBC

import UIKit

extension SignUpViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.signUpViewModel.arrayOfCells.count
        
    }
    // swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.signUpViewModel.arrayOfCells[indexPath.row]
        
        switch cellType {
            
        case .cellTittle:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TittleWithDescriptionTableViewCell
            cell.strTittle = signUpViewModel.titles.tittleREGISTER_WITH_EMAIL
                
            cell.configureEmailCell()
            return cell
            
        case .cellName:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! TextfieldTableViewCell
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = signUpViewModel.titles.namePlaceHolder
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 12, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            self.txtname = cell.textfield
            cell.textfield.textfield.text = self.signUpViewModel.name
            self.txtname?.textfield.clearsOnBeginEditing = false
            self.txtname?.textfield.tag = TextFieldTag.name.rawValue
            cell.textfield.textfield.borderStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            self.addActionsForNameText(txtName: cell.textfield)
            cell.textfield.textfield.keyboardType = UIKeyboardType.alphabet
            switch self.signUpViewModel.validationStateEmail {
            case .valid:
                break
            case .inValid(let error):
                self.txtname.setState(state: CustomTextfieldView.FieldState.error)
                self.txtname.configureError(error: error)
                break
            }
            cell.selectionStyle = .none
        
            return cell
        case .cellEmail:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! TextfieldTableViewCell
            
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = signUpViewModel.titles.emailAddressPlaceHolder
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            self.txtEmail = cell.textfield
            cell.textfield.textfield.text = signUpViewModel.emailID
            txtEmail?.textfield.clearsOnBeginEditing = false
            txtEmail?.textfield.tag = TextFieldTag.email.rawValue
            cell.textfield.textfield.borderStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            self.addActionsForEmailAddress(txtEmail: cell.textfield)
            cell.textfield.textfield.keyboardType = UIKeyboardType.emailAddress
            switch signUpViewModel.validationStateEmail {
            case .valid:
                break
            case .inValid(let error):
                txtEmail.setState(state: CustomTextfieldView.FieldState.error)
                txtEmail.configureError(error: error)
                break
            }
            cell.selectionStyle = .none
            return cell
        case .cellPassword:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! TextfieldTableViewCell
            cell.backgroundColor = UIColor.clear
            
            var config = TextfieldTableViewCellConfig()
            config.placeHolder = signUpViewModel.titles.passwordPlaceholder
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            cell.textfield.textfield.text = signUpViewModel.password
            cell.contentView.backgroundColor = .clear
            txtPassword = cell.textfield
            txtPassword?.textfield.isSecureTextEntry = true
            txtPassword?.textfield.clearsOnBeginEditing = false
            txtPassword?.textfield.tag = TextFieldTag.password.rawValue
            switch self.signUpViewModel.validationStatePassword {
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
            config.placeHolder = signUpViewModel.titles.confirmPasswordPlaceholder
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            cell.textfield.textfield.text = signUpViewModel.confirmPassword
            cell.contentView.backgroundColor = UIColor.clear
            txtConfirmPassword = cell.textfield
            txtConfirmPassword?.textfield.isSecureTextEntry = true
            txtConfirmPassword?.textfield.clearsOnBeginEditing = false
            txtConfirmPassword?.textfield.tag = TextFieldTag.password.rawValue
            switch self.signUpViewModel.validationStateConfirmPassword {
                
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
            let title =  signUpViewModel.titles.btnRegisterPlaceholder
            if self.btnSIgnUp == nil {
                  self.btnSIgnUp = cell.btnAction
                self.btnSIgnUp.isEnabled = false
            }
            if self.btnSIgnUp.isEnabled {
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
              cell.configure(title: title)
            cell.btnAction.addTarget(self, action: #selector(SignUpButtonAction(_ :)), for: UIControl.Event.touchUpInside)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            return cell
            
        case .cellLoginBtn:
              guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoginbuttonCell", for: indexPath) as? ButtonTableViewCell  else {
                           fatalError("The dequeued cell is not an instance of MWRButtonTableViewCell.")
                       }
                       
            let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20),
                                                             buttonBackgroundColor: UIColor.white,
                                                             buttonTextColor: UIColor(colorConfig.primary_button_color!)!,
                                                             buttonFont: AppManager.appStyle.font(for: .primaryActionButton),
                                                             borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 3)
                       cell.configureViewModel(model: vmForButton)
              let title = signUpViewModel.titles.loginPlacholder
            cell.configure(title: title)
            cell.btnAction.titleLabel?.text = title
            cell.btnAction.addTarget(self, action: #selector(logindButtonAction(_:)), for: UIControl.Event.touchUpInside)
            cell.btnAction.contentHorizontalAlignment = .center
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
