//
//  CreatePasswordViewModel.swift
//  SBC

import Foundation
import UIKit

protocol CreateNewPasswordDataPassingDelegate: class {
    func failureWithError(message: String)
    func signUpSuccess()
}

protocol CreateNewPassworViewModelProtocol {
     var delegate: CreateNewPasswordDataPassingDelegate? { get set }
    func callResetPasswordAPI(request: ResetPasswordRequest)
}

class CreateNewPasswordViewModel: BaseViewModel, CreateNewPassworViewModelProtocol {
    
    let userManager = UserManager(dataStore: APIStore.instance)
    override init() {}
    
    init(signUp: SignUpRequest?) {
        createNewPasswordModel.email = signUp?.email
        createNewPasswordModel.password = signUp?.password
    }
    
    private func getCells() -> [CreateNewPasswordCells] {
        var cell = [CreateNewPasswordCells]()
        cell.append(.cellTittle)
        cell.append(.cellPassword)
        cell.append(.cellConfirmPassword)
        cell.append(.cellValidation)
        cell.append(.cellSubmitBtn)
        return cell
    }
    
    var validationStatePassword = ValidationState.valid
    var validationStateConfirmPassword = ValidationState.valid
    private var createNewPasswordModel = CreateNewPasswordModel()
    weak var delegate: CreateNewPasswordDataPassingDelegate?
    var token: String?  = ""
    let titles = CreatePassword.Titles()
    var images: Images = Images()
    let messages = CreatePassword.Messages()
    var arrayOfCells = [CreateNewPasswordCells]()
    
    var emailID: String {
        return createNewPasswordModel.email ?? ""
    }
    
    var password: String {
        return createNewPasswordModel.password ?? ""
    }
    var confirmPassword: String {
        return createNewPasswordModel.confirmPassword ?? ""
    }
    
    public func getCells() {
        self.arrayOfCells.removeAll()
        self.arrayOfCells = getCells()
    }
    
    public func updateEmail(email: String?) {
        guard let text = email else {
            return
        }
        self.createNewPasswordModel.email = text
    }
    
    public func updatePassword(password: String?) {
        guard let text = password else {
            return
        }
        createNewPasswordModel.password = text
    }
    
    public func updateConfirmPassword(password: String?) {
        guard let text = password else {
            return
        }
        createNewPasswordModel.confirmPassword = text
    }
    
    // MARK: - Validations
    
    public  func validatePassword() -> ValidationState {
        
        let validationRule =  Validator.validate(createNewPasswordModel.password, rules: [.required, .oneCapitalLetter, .oneSmallLetter, .minLengthPassword])
        
        if arrayOfCells.contains(.cellPassword) {
            if  validationRule == .required {
                return .inValid(messages.emptyPassword)
            }
            if validationRule == .oneCapitalLetter || validationRule == .oneSmallLetter || validationRule == .minLengthPassword {
                return .inValid(messages.passwordValidation)
            }
            if validationRule != .valid {
                return .inValid(localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED"))
            }
        }
        return .valid
    }
    
    public  func validateConfirmPassword() -> ValidationState {
        let validationRule =  Validator.validate(createNewPasswordModel.confirmPassword, rules: [.required])
        
        if arrayOfCells.contains(.cellConfirmPassword) {
            if  validationRule == .required {
                return .inValid(messages.emptyPasswordConfirm)
            }
            if validationRule != .valid {
                return .inValid("")
            }
        }
        return .valid
    }
    
    func callResetPasswordAPI(request: ResetPasswordRequest) {
        userManager.performResetPassword(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                self.delegate?.signUpSuccess()
            case .failure( let error):
                self.delegate?.failureWithError(message: "")
            }
        }
    }
    
}
