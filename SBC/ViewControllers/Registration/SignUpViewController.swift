//
//  SignUpViewController.swift
//  SBC
//

import UIKit
import IQKeyboardManagerSwift

class SignUpViewController: BaseViewController, UITextFieldDelegate, SignUpViewModelDelegate {
    
    @IBOutlet weak var signUpTableView: UITableView!
    
    var txtPassword: CustomTextfieldView!
    var txtEmail: CustomTextfieldView!
    var txtname: CustomTextfieldView!
    var btnSIgnUp: UIButton!
    var btnCountryCode: UIButton!
    var btnShowPassword: UIButton!
    var btnShowConfirmPassword: UIButton!
    var txtConfirmPassword: CustomTextfieldView!
    var signUpViewModel = SignUpViewModel()
    var errorMessage: String?
    var successMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    // MARK: UI setup
    private func setUpUI() {
        signUpViewModel.delegate = self
        signUpTableView.delegate = self
        signUpTableView.dataSource = self
        signUpViewModel.getCells()
        registerNib()
        signUpTableView.estimatedRowHeight = UITableView.automaticDimension
        signUpTableView.rowHeight = UITableView.automaticDimension
        showScreenTitleWithLeftBarButton()
        self.signUpTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
    }
    
    private func registerNib() {
        signUpTableView.separatorStyle = .none
        signUpTableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "passwordCell")
        signUpTableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "nameCell")
        signUpTableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "confirmPasswordCell")
        signUpTableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "emailCell")
        signUpTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "buttonCell")
        signUpTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LoginbuttonCell")
        signUpTableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TittleWithDescriptionTableViewCell")
        
        signUpTableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ValidationCell")
        
    }
    
    // MARK: - ViewModel Methods
    
    func signUpFailureWithError(message: String) {
        if message == K.Email_Already_Exist {
            let  titleUpdated = localizedStringForKey(key: "alert.email.already.exist")
            CommonAlertHandler.showErrorResponseAlert(for: titleUpdated)
        } else {
             CommonAlertHandler.showErrorResponseAlert(for: message)
        }
        
    }
    
    func signUpSuccess(signUpResponse: SignUpResponse) {
        navigateToOTPHandlerVC()
    }
    
    // MARK: Private funcn
    
    func handleRegisterButtonState() {
        btnSIgnUp.isEnabled = signUpViewModel.isAllDataValid
        let indexPath = IndexPath(row: SignupCells.cellSubmitBtn.rawValue, section: 0)
        signUpTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func addActionsForEmailAddress(txtEmail: CustomTextfieldView) {
        txtEmail.textfield.delegate = self
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    func addActionsForNameText(txtName: CustomTextfieldView) {
        txtName.textfield.delegate = self
        txtName.textfield.addTarget(self, action: #selector(self.nameTxtDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        txtName.textfield.addTarget(self, action: #selector(self.nameTxtEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtName.textfield.addTarget(self, action: #selector(self.nameTxtEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
        
    }
    
    // MARK: Textfield delegates
    
    @IBAction func nameTxtEditingDidBegin(_ sender: Any) {
        
        if txtname.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtname.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func nameTxtEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField
        signUpViewModel.updateName(name: textfield?.text)
        
    }
    
    @IBAction func nameTxtEditingDidEnd(_ sender: Any) {
        
        if txtname.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtname.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ = validateName()
        
        debugPrint(txtname.textfield.text)
        handleRegisterButtonState()
        
    }
    
    @objc func nameTxtDidBeginEditing(_ sender: UITextField) {
        _ = self.applyStateOnTextfield(textfield: txtname, state: .valid, tableView: signUpTableView)
        if self.txtname?.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtname?.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @objc func nameTxtDidEndEditing(_ sender: UITextField) {
        if txtname?.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtname?.setState(state: CustomTextfieldView.FieldState.normal)
        }
        
    }
    
    @IBAction func emailAddressEditingDidBegin(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtEmail, state: .valid, tableView: signUpTableView)
        if txtEmail.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtEmail.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func emailAddressEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField
        signUpViewModel.updateEmail(email: textfield?.text)
        
    }
    
    @IBAction func emailAddressEditingDidEnd(_ sender: Any) {
        if txtEmail.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtEmail.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ = validateEmailAddress()
        handleRegisterButtonState()
    }
    
    @objc func emailDidBeginEditing(_ sender: UITextField) {
        
        if self.txtEmail?.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtEmail?.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @objc func emailDidEndEditing(_ sender: UITextField) {
        if txtEmail?.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtEmail?.setState(state: CustomTextfieldView.FieldState.normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField != txtname.textfield {
            if string == " " {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.btnSIgnUp != nil {
            print("Continue")
        }
        return true
    }
    
    // MARK: Validations
    private  func validate() -> ValidationState {
        let nameValidationstate    = validateName()
        let passordValidationstate = validatePassword()
        let emailValidationstate = validateEmailAddress()
        let confirmPasswordValidationstate = validateConfirmPassword()
        
        switch (nameValidationstate, passordValidationstate, emailValidationstate, confirmPasswordValidationstate) {
        case (.valid, .valid, .valid, .valid):
            return .valid
        default:
            break
        }
        return .inValid("")
    }
    
    func validateName() -> ValidationState {
        let validationState = signUpViewModel.validateName()
        if signUpViewModel.arrayOfCells.contains(.cellName) {
            guard let textfield = txtname else {
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
    }
    
    func validateEmailAddress() -> ValidationState {
        let validationState = signUpViewModel.validateEmailId()
        if signUpViewModel.arrayOfCells.contains(.cellEmail) {
            guard let textfield = txtEmail else {
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
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
        signUpTableView.beginUpdates()
        signUpTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        return state
    }
    
    // MARK: - Password Fileds methods
    
    func setUpShowPasswordPanel() {
        btnShowPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: txtPassword.textfield.frame.size.height))
        btnShowPassword.contentMode = .center
        btnShowPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowPassword.setImage(image: UIImage(named: ImageConstants.hidePassword), tintColor: .themeDarkBlue, forUIControlState: .normal)
        btnShowPassword.setImage(image: UIImage(named: ImageConstants.showPassword), tintColor: .themeDarkBlue, forUIControlState: .selected)
        btnShowPassword.addTarget(self, action: #selector(self.btnShowPasswordClicked), for: .touchUpInside)
        txtPassword.configureRightPanel(rightButton: btnShowPassword)
    }
    
    func setUpShowConfirmPasswordPanel() {
        btnShowConfirmPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: txtConfirmPassword.textfield.frame.size.height))
        btnShowConfirmPassword.contentMode = .center
        btnShowConfirmPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowConfirmPassword.setImage(image: UIImage(named: ImageConstants.hidePassword), tintColor: .themeDarkBlue, forUIControlState: .normal)
        btnShowConfirmPassword.setImage(image: UIImage(named: ImageConstants.showPassword), tintColor: .themeDarkBlue, forUIControlState: .selected)
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
        signUpViewModel.updatePassword(password: textfield?.text)
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        if txtPassword.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtPassword.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ =  validatePassword()
        handleRegisterButtonState()
    }
    
    private func validatePassword() -> ValidationState {
        let validationState = signUpViewModel.validatePassword()
        if signUpViewModel.arrayOfCells.contains(.cellPassword) {
            guard let textfield = txtPassword else {
                
                return .inValid(localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED"))
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
        signUpViewModel.updateConfirmPassword(password: textfield?.text)
        
    }
    @IBAction func confirmPasswordEditingDidEnd(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: .valid)
        if txtConfirmPassword.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtConfirmPassword.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ =  validateConfirmPassword()
        if txtPassword.getText() != txtConfirmPassword.getText() && signUpViewModel.validatePassword() == .valid {
            _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: ValidationState.inValid(localizedStringForKey(key: "MSG_CONFIRM_PASSWORD_NOT_MATCH_MSG_TEXT", "")))
            btnSIgnUp.isEnabled = false
            
            let indexPath = IndexPath(row: 6, section: 0)
            signUpTableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        handleRegisterButtonState()
        signUpTableView.reloadData()
    }
    
    private func validateConfirmPassword() -> ValidationState {
        let validationState = signUpViewModel.validateConfirmPassword()
        if signUpViewModel.arrayOfCells.contains(.cellConfirmPassword) {
            guard let textfield = txtConfirmPassword else {
                return .inValid("No textfield")
            }
            return applyStateOnTextfield(textfield: textfield, state: validationState)
        }
        return validationState
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button Actions
    @IBAction func SignUpButtonAction(_ sender: UIButton) {
        
        btnSIgnUp = sender
        self.view.endEditing(true)
        
        if signUpViewModel.arrayOfCells.contains(.cellName) {
            signUpViewModel.updateName(name: txtname.getText())
        }
        if signUpViewModel.arrayOfCells.contains(.cellEmail) {
            signUpViewModel.updateEmail(email: txtEmail.getText())
        }
        if signUpViewModel.arrayOfCells.contains(.cellPassword) {
            signUpViewModel.updatePassword(password: txtPassword.getText())
        }
        
        if signUpViewModel.arrayOfCells.contains(.cellConfirmPassword) {
            signUpViewModel.updateConfirmPassword(password: txtConfirmPassword.getText())
        }
        
        if txtPassword.getText() != txtConfirmPassword.getText() {
            _ = self.applyStateOnTextfield(textfield: txtConfirmPassword, state: ValidationState.inValid(localizedStringForKey(key: "MSG_CONFIRM_PASSWORD_NOT_MATCH_MSG_TEXT", "")))
            return
        }
        
        let validationState = validate()
        if validationState == .valid {
            self.btnSIgnUp.isEnabled = true
            signUpViewModel.callSignUpAPI(type: "email")
        } else {
            self.btnSIgnUp.isEnabled = false
        }
        signUpTableView.reloadData()
    }
    
    @objc func logindButtonAction(_ sender: Any) {
        RootViewControllerRouter.setLoginNavAsRootVC(animated: true)
    }
    
    private func navigateToOTPHandlerVC() {
        let vc = OTPHandlingViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Verification, storyboardId: StoryboardId.OTPHandlingViewController)
        let model = OTPModel(title: K.Verify_Email_Title, desc: K.Verify_Email_Desc, contactInfo: txtEmail.getText(), resendTitle: K.Verify_Email_Resend_Title)
        vc.viewModel?.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
