//
//  PasswordRecoveryViewController.swift
//  SBC

import UIKit

class PasswordRecoveryViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordRecoveryTableView: UITableView!
    var txtEmail: CustomTextfieldView!
    var btnProceed: UIButton!
    var viewModel = PasswordRecoveryViewModel()
    var errorMessage: String?
    var successMessage: String?
    var activeTextfield: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: UI setup
    private func setUpUI() {
        viewModel.delegate = self
        passwordRecoveryTableView.delegate = self
        passwordRecoveryTableView.dataSource = self
        viewModel.getCells()
        registerNib()
        passwordRecoveryTableView.estimatedRowHeight = 60
        passwordRecoveryTableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.isNavigationBarHidden = true
        self.showTopView()
    }
    
    private func registerNib() {
        passwordRecoveryTableView.separatorStyle = .none
        passwordRecoveryTableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "emailCell")
        passwordRecoveryTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "buttonCell")
        passwordRecoveryTableView.register(UINib(nibName: "TittleWithDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TittleCell")
    }
    
    private func getErrorMessage(for message: String) -> String {
        if message.contains(K.User_Not_Found) {
            return localizedStringForKey(key: "EMAIL_NOT_REGISTERED")
        }
        return "Somethng Unexpected Happend, try again"
    }
    
    func addActionsForEmailAddress(txtEmail: CustomTextfieldView) {
        txtEmail.textfield.delegate = self
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingDidBegin(_:)), for: UIControl.Event.editingDidBegin)
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingChange(_:)), for: UIControl.Event.editingChanged)
        txtEmail.textfield.addTarget(self, action: #selector(self.emailAddressEditingDidEnd(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    @IBAction func didTappedNextButtonAction(_ sender: UIButton) {
        
        btnProceed = sender
        self.view.endEditing(true)
        if viewModel.arrayOfCells.contains(.cellEmail) {
            viewModel.updateEmail(email: txtEmail.getText())
        }
        let validationState = validate()
        if validationState == .valid {
            let request = ForgotPasswordRequest(email: txtEmail.textfield.text ?? "")
            viewModel.callForgotPasswordApi(request: request)
        }
    }
    
    private func navigateToOTPHandlerVC() {
        let vc = OTPHandlingViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Verification, storyboardId: StoryboardId.OTPHandlingViewController)
        let model = OTPModel(title: K.Password_Recovery_Title, desc: K.Password_Recovery_Desc, contactInfo: txtEmail.textfield.text ?? "", resendTitle: K.Password_Recovery_Resend_Title)
        vc.viewModel?.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Validations
    private  func validate() -> ValidationState {
        
        let emailValidationstate = validateEmailAddress()
        switch emailValidationstate {
        case (.valid):
            return .valid
        default:
            break
        }
        return .inValid("")
    }
    
    func validateEmailAddress() -> ValidationState {
        let validationState = viewModel.validateEmailId()
        if viewModel.arrayOfCells.contains(.cellEmail) {
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
        passwordRecoveryTableView.beginUpdates()
        passwordRecoveryTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        return state
    }
    
    // MARK: TextField Methods
    
    @IBAction func emailAddressEditingDidBegin(_ sender: Any) {
        _ = self.applyStateOnTextfield(textfield: txtEmail, state: .valid, tableView: passwordRecoveryTableView)
        if txtEmail.getCurrentState() == CustomTextfieldView.FieldState.normal {
            txtEmail.setState(state: CustomTextfieldView.FieldState.editing)
        }
    }
    
    @IBAction func emailAddressEditingChange(_ sender: Any) {
        let textfield: UITextField? = sender as? UITextField
        viewModel.updateEmail(email: textfield?.text)
        
    }
    
    @IBAction func emailAddressEditingDidEnd(_ sender: Any) {
        if txtEmail.getCurrentState() == CustomTextfieldView.FieldState.editing {
            txtEmail.setState(state: CustomTextfieldView.FieldState.normal)
        }
        _ = validateEmailAddress()
        
        let validationState = validate()
        if validationState == .valid {
            btnProceed.isEnabled = true
        } else {
            btnProceed.isEnabled = false
        }
        passwordRecoveryTableView.reloadData()
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.btnProceed != nil {
            print("Continue")
        }
        return true
    }
}

extension PasswordRecoveryViewController: PasswordRecoveryDataPassingDelegate {
    func successHandler() {
        CommonUtil.sharedInstance.removeLoader()
        navigateToOTPHandlerVC()
    }
    
    func failureHandler(message: String) {
        CommonUtil.sharedInstance.removeLoader()
        txtEmail.setState(state: CustomTextfieldView.FieldState.error)
        txtEmail.configureError(error: getErrorMessage(for: message))
        passwordRecoveryTableView.reloadData()
    }
}
