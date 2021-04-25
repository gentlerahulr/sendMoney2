//
//  CreateNewPasswordViewController.swift
//  SBC
//

import UIKit

class CreateNewPasswordViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var btnUpadte: UIButton!
    var btnShowPassword: UIButton!
    var btnShowConfirmPassword: UIButton!
    var txtPassword: CustomTextfieldView!
    var txtConfirmPassword: CustomTextfieldView!
    var viewModel =  CreateNewPasswordViewModel()
    var emailId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UI setup
    private func setUpUI() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.getCells()
        registerNib()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        showScreenTitleWithLeftBarButton()
        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }
    
    private func registerNib() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "passwordCell")
        tableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "confirmPasswordCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TittleWithDescriptionTableViewCell")
        tableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ValidationCell")
        
    }
    // MARK: Validations
    private  func validate() -> ValidationState {
        let passordValidationstate = validatePassword()
        let confirmPasswordValidationstate = validateConfirmPassword()
        
        switch (passordValidationstate, confirmPasswordValidationstate) {
        case (.valid, .valid):
            return .valid
        default:
            break
        }
        return .inValid("")
    }
    
    private func applyStateOnTextfield(textfield: CustomTextfieldView, state: ValidationState) -> ValidationState {
        switch state {
        case .valid:
            let state = textfield.textfield.isFirstResponder ? CustomTextfieldView.FieldState.editing :  CustomTextfieldView.FieldState.normal
            textfield.setState(state: state)
        case .inValid(let error):
            textfield.setState(state: CustomTextfieldView.FieldState.error)
            textfield.configureError(error: error)
        }
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        return state
    }
    
    // MARK: - Password Fileds methods
    
    func setUpShowPasswordPanel() {
        btnShowPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: txtPassword.textfield.frame.size.height))
        btnShowPassword.contentMode = .center
        btnShowPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let color = UIColor(colorConfig.primary_text_color!)
        btnShowPassword.setImage(image: UIImage(named: ImageConstants.hidePassword), tintColor: color, forUIControlState: .normal)
        btnShowPassword.setImage(image: UIImage(named: ImageConstants.showPassword), tintColor: color, forUIControlState: .selected)
        btnShowPassword.addTarget(self, action: #selector(self.btnShowPasswordClicked), for: .touchUpInside)
        txtPassword.configureRightPanel(rightButton: btnShowPassword)
    }
    
    func setUpShowConfirmPasswordPanel() {
        btnShowConfirmPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: txtConfirmPassword.textfield.frame.size.height))
        btnShowConfirmPassword.contentMode = .center
        btnShowConfirmPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let color = UIColor(colorConfig.primary_text_color!)
        btnShowConfirmPassword.setImage(image: UIImage(named: ImageConstants.hidePassword), tintColor: color, forUIControlState: .normal)
        btnShowConfirmPassword.setImage(image: UIImage(named: ImageConstants.showPassword), tintColor: color, forUIControlState: .selected)
        btnShowConfirmPassword.addTarget(self, action: #selector(self.btnShowConfirmPasswordClicked(_:)), for: .touchUpInside)
        txtConfirmPassword.configureRightPanel(rightButton: btnShowConfirmPassword)
    }
    
    @objc func btnShowPasswordClicked(_ sender: UIButton) {
        txtPassword.textfield.isSecureTextEntry = !txtPassword.textfield.isSecureTextEntry
        btnShowPassword.isSelected = !txtPassword.textfield.isSecureTextEntry
        let text = txtPassword.textfield.text
        txtPassword.textfield.text = " "
        txtPassword.textfield.text = text
    }
    
    @objc func btnShowConfirmPasswordClicked(_ sender: UIButton) {
        txtConfirmPassword.textfield.isSecureTextEntry = !txtConfirmPassword.textfield.isSecureTextEntry
        btnShowConfirmPassword.isSelected = !txtConfirmPassword.textfield.isSecureTextEntry
        let text = txtConfirmPassword.textfield.text
        txtConfirmPassword.textfield.text = " "
        txtConfirmPassword.textfield.text = text
    }
    
    func addActionsForPasswordField(txtPassword: CustomTextfieldView) {
        txtPassword.textfield.delegate = self
        txtPassword.textfield.addTarget(self, action: #selector(self.passwordEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        txtPassword.textfield.addTarget(self, action: #selector(self.passwordEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtPassword.textfield.addTarget(self, action: #selector(self.passwordEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    func addActionsForConfirmPasswordField(txtConfirmPassword: CustomTextfieldView) {
        txtConfirmPassword.textfield.delegate = self
        txtConfirmPassword.textfield.addTarget(self, action: #selector(self.confirmPasswordEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        txtConfirmPassword.textfield.addTarget(self, action: #selector(self.confirmPasswordEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtConfirmPassword.textfield.addTarget(self, action: #selector(self.confirmPasswordEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
    }
    @IBAction func passwordEditingDidBegin(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtPassword, state: .valid)
        
        if txtPassword.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtPassword.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func passwordEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField
        viewModel.updatePassword(password: textfield?.text)
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        if txtPassword.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtPassword.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ =  validatePassword()
    }
    
    private func validatePassword() -> ValidationState {
        let validationState = viewModel.validatePassword()
        if viewModel.arrayOfCells.contains(.cellPassword) {
            guard let textfield = txtPassword else {
                
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
    }
    
    @IBAction func confirmPasswordEditingDidBegin(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: .valid)
        
        if txtConfirmPassword.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtConfirmPassword.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func confirmPasswordEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField
        viewModel.updateConfirmPassword(password: textfield?.text)
    }
    @IBAction func confirmPasswordEditingDidEnd(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: .valid)
        if txtConfirmPassword.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtConfirmPassword.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ =  validateConfirmPassword()
        if txtPassword.getText() != txtConfirmPassword.getText() && viewModel.validatePassword() == .valid {
            _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: ValidationState.inValid(localizedStringForKey(key: "MSG_CONFIRM_PASSWORD_NOT_MATCH_MSG_TEXT", "")))
            
            btnUpadte.isEnabled = false
            
            let indexPath = IndexPath(row: 4, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        
        let validationState = validate()
        if validationState == .valid {
            btnUpadte.isEnabled = true
        } else {
            btnUpadte.isEnabled = false
        }
        tableView.reloadData()
    }
    
    private func validateConfirmPassword() -> ValidationState {
        let validationState = viewModel.validateConfirmPassword()
        if viewModel.arrayOfCells.contains(.cellConfirmPassword) {
            guard let textfield = txtConfirmPassword else {
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
    }
    
    // MARK: - Button Actions
    @IBAction func didTappedUpdatePasswordButtonAction(_ sender: UIButton) {
        
        btnUpadte = sender
        self.view.endEditing(true)
        
        if viewModel.arrayOfCells.contains(.cellPassword) {
            viewModel.updatePassword(password: txtPassword.getText())
        }
        
        if viewModel.arrayOfCells.contains(.cellConfirmPassword) {
            viewModel.updateConfirmPassword(password: txtConfirmPassword.getText())
        }
        
        if txtPassword.getText() != txtConfirmPassword.getText() {
            _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: ValidationState.inValid(localizedStringForKey(key: "MSG_CONFIRM_PASSWORD_NOT_MATCH_MSG_TEXT", "")))
            return
        }
        
        let validationState = validate()
        if validationState == .valid {
            CommonUtil.sharedInstance.showLoader()
            let request = ResetPasswordRequest(deviceId: K.deviceId, password: txtPassword.textfield.text ??  "", email: emailId)
            viewModel.callResetPasswordAPI(request: request)
        } else {
            
        }
    }
    
    private func navigateToPasswordSuccesVC() {
        let vc = NotificationSuccessViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Notification, storyboardId: StoryboardId.NotificationSuccessViewController)
        let noticationSuccessModel = NotificationSuccessModel(titleText: NotificationMessage.passwordUpdateMessage, successButtonText: CommonButton.loginButton)
        vc.viewModel?.dataModel = noticationSuccessModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if string == " " {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.btnUpadte != nil {
            print("Continue")
        }
        return true
    }
    
}// MARK: ViewModel Delegate Method
extension CreateNewPasswordViewController: CreateNewPasswordDataPassingDelegate {
    
    func failureWithError(message: String) {
        print("failureWithError")
        CommonUtil.sharedInstance.removeLoader()
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func signUpSuccess() {
        CommonUtil.sharedInstance.removeLoader()
        navigateToPasswordSuccesVC()
    }
    
}
