//
//  SignUpViewModel.swift
//  SBC
//

import Foundation
import UIKit

protocol SignUpViewModelDelegate: class {
    func signUpFailureWithError(message: String)
    func signUpSuccess(signUpResponse: SignUpResponse)
}

class SignUpViewModel: BaseViewModel {
    
    override init() {}
    
    init(signUp: SignUpRequest?) {
        signUpModel.name = signUp?.name
        signUpModel.email = signUp?.email
        signUpModel.password = signUp?.password
    }
    
    private func getCellsForSignUp() -> [SignupCells] {
        var cell = [SignupCells]()
        cell.append(.cellTittle)
        cell.append(.cellName)
        cell.append(.cellEmail)
        cell.append(.cellPassword)
        cell.append(.cellConfirmPassword)
        cell.append(.cellValidation)
        cell.append(.cellSubmitBtn)
        cell.append(.cellLoginBtn)
        return cell
    }
    
    var validationStateName = ValidationState.valid
    var validationStatePassword     = ValidationState.valid
    var validationStateEmail        = ValidationState.valid
    var validationStateConfirmPassword     = ValidationState.valid
    private var signUpModel  = SignUpModel()
    weak var delegate: SignUpViewModelDelegate?
    var token: String?  = ""
    let titles       = Titles()
    var images: Images = Images()
    let messages     = Messages()
    var arrayOfCells = [SignupCells]()
    var signUpRequest: SignUpRequest?
    var signUpResponse: SignUpResponse?
    let userManager = UserManager(dataStore: APIStore.instance)
    private var isValidName: Bool = false
    private var isValidEmail: Bool = false
    private  var isValidPassword: Bool = false
    private var isVailidConfirmPassword: Bool = false
    
    var isAllDataValid: Bool {
        return isValidName && isValidEmail && isValidPassword && isVailidConfirmPassword
    }
    
    var emailID: String {
        return signUpModel.email ?? ""
    }
    
    var name: String {
        return signUpModel.name ?? ""
    }
    
    var password: String {
        return signUpModel.password ?? ""
    }
    var confirmPassword: String {
        return signUpModel.confirmPassword ?? ""
    }
    
    var appleId: String {
        return signUpModel.appleId ?? ""
    }
    
    var facebookId: String {
        return signUpModel.facebookId ?? ""
    }
    
    public func getCells() {
        self.arrayOfCells.removeAll()
        self.arrayOfCells = getCellsForSignUp()
    }
    
    public func updateName(name: String?) {
        guard let text = name else {
            return
        }
        self.signUpModel.name = text
    }
    
    public func updateEmail(email: String?) {
        guard let text = email else {
            return
        }
        self.signUpModel.email = text
    }
    
    public func updatePassword(password: String?) {
        guard let text = password else {
            return
        }
        signUpModel.password = text
    }
    
    public func updateConfirmPassword(password: String?) {
        guard let text = password else {
            return
        }
        signUpModel.confirmPassword = text
    }
    
    public func updateAppleId(appleId: String?) {
        guard let text = appleId else {
            return
        }
        signUpModel.appleId = text
    }
    
    public func updateFacebookId(facebookId: String?) {
        guard let text = facebookId else {
            return
        }
        signUpModel.facebookId = text
    }
    
    // MARK: - Validations
    
    public  func validatePassword() -> ValidationState {
        isValidPassword = false
        let validationRule =  Validator.validate(signUpModel.password, rules: [.required, .oneCapitalLetter, .oneSmallLetter, .minLengthPassword])
        
        if arrayOfCells.contains(.cellPassword) {
            if  validationRule == .required {
                return .inValid(messages.emptyPassword)
            }
            if validationRule == .oneCapitalLetter || validationRule == .oneSmallLetter || validationRule == .minLengthPassword {
                return .inValid(localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED"))
            }
            if validationRule != .valid {
                return .inValid(localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED"))
            }
        }
        isValidPassword = true
        return .valid
    }
    
    public  func validateConfirmPassword() -> ValidationState {
        isVailidConfirmPassword = false
        let validationRule =  Validator.validate(signUpModel.confirmPassword, rules: [.required])
        
        if arrayOfCells.contains(.cellConfirmPassword) {
            if  validationRule == .required {
                return .inValid(messages.emptyPasswordConfirm)
            }
            if validationRule != .valid {
                return .inValid("")
            }
        }
        isVailidConfirmPassword = true
        return .valid
    }
    
    public func validateEmailId() -> ValidationState {
        isValidEmail = false
        if arrayOfCells.contains(.cellEmail) {
            if Validator.validate(signUpModel.email, rules: [.required]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "MSG_EMPTY_EMAIL", ""))
            } else if  Validator.validate(signUpModel.email, rules: [.email]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "Email_format_is_incorrect", ""))
            } else if signUpModel.email?.count ?? 1 > 87 {
                return .inValid(localizedStringForKey(key: "Email_Maximum_number_of_characters_exceeds", ""))
            }
        }
        isValidEmail = true
        return .valid
    }
    
    public func validateName() -> ValidationState {
        isValidName = false
        if arrayOfCells.contains(.cellEmail) {
            if Validator.validate(signUpModel.name, rules: [.required]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "MSG_EMPTY_Name", ""))
            } else if Validator.validate(signUpModel.name, rules: [.alphaNumericWithSpace, .maxLength(50), .minLength(2)]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "ENTER_VALID_NAME"))
            } else if signUpModel.name?.trim().count == 0 {
                return .inValid(localizedStringForKey(key: "ENTER_VALID_NAME", ""))
            }
        }
        isValidName = true
        return .valid
    }
    
    // MARK: Call APi
    
    func callSignUpAPI(type: String) {
        self.signUpRequest = SignUpRequest()
        self.signUpRequest?.name = signUpModel.name
        self.signUpRequest?.email = signUpModel.email
        self.signUpRequest?.password = signUpModel.password
        self.signUpRequest?.facebookId = signUpModel.facebookId
        self.signUpRequest?.appleId = signUpModel.appleId
        self.signUpRequest?.registrationType = type
        
        guard let signUpRequest = self.signUpRequest else {
            return
        }
        if let email = signUpRequest.email {
            KeyChainServiceWrapper.standard.userEmail = email
        }
        
        CommonUtil.sharedInstance.showLoader()
    
        userManager.performSignUp(request: signUpRequest, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let signUpData):
                self.signUpResponse = signUpData
                self.delegate?.signUpSuccess(signUpResponse: signUpData)
            case .failure( let error):
                self.delegate?.signUpFailureWithError(message: error.localizedDescription)
                
            }
        })
    }
}
