//
//  PasswordRecoveryViewModel.swift
//  SBC
//

import Foundation
import UIKit

protocol PasswordRecoveryDataPassingDelegate: AnyObject {
    func failureHandler(message: String)
    func successHandler()
}

protocol PasswordRecoveryViewModelProtocol: AnyObject {
    var delegate: PasswordRecoveryDataPassingDelegate? { get set }
    func callForgotPasswordApi(request: ForgotPasswordRequest)
}

class PasswordRecoveryViewModel: BaseViewModel, PasswordRecoveryViewModelProtocol {
    
    override init() {}
    
    let userManager: UserManager = UserManager(dataStore: APIStore.instance)
    private func getCells() -> [PasswordRecoveryCells] {
        var cell = [PasswordRecoveryCells]()
        cell.append(.cellTittle)
        cell.append(.cellEmail)
        cell.append(.cellProceddBtn)
        return cell
    }
    
    var validationStateEmail        = ValidationState.valid
    private var passwordrecoveryModel  = PasswordrecoveryModel()
    weak var delegate: PasswordRecoveryDataPassingDelegate?
    let titles       = PasswordRecovery.Titles()
    let messages     = PasswordRecovery.Messages()
    var arrayOfCells = [PasswordRecoveryCells]()
    
    public func getCells() {
        self.arrayOfCells.removeAll()
        self.arrayOfCells = getCells()
    }
    
    var emailID: String {
        return passwordrecoveryModel.email ?? ""
    }
    
    public func updateEmail(email: String?) {
        guard let text = email else {
            return
        }
        self.passwordrecoveryModel.email = text
    }
    
    public func validateEmailId() -> ValidationState {
        if arrayOfCells.contains(.cellEmail) {
            if Validator.validate(passwordrecoveryModel.email, rules: [.required]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "MSG_EMPTY_EMAIL", ""))
            } else if  Validator.validate(passwordrecoveryModel.email, rules: [.email]) != ValidatorRule.valid {
                return .inValid(localizedStringForKey(key: "Email_format_is_incorrect", ""))
            } else if passwordrecoveryModel.email?.count ?? 1 > 87 {
                return .inValid(localizedStringForKey(key: "Email_Maximum_number_of_characters_exceeds", ""))
            }
        }
        return .valid
    }
    
    func callForgotPasswordApi(request: ForgotPasswordRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.performForgotPassword(request: request) { (result: Result<ForgotPasswordResponse, APIError>) in
            switch result {
            case .success(let model):
                self.delegate?.successHandler()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
}
