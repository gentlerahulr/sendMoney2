//
//  CreateNewPasswordVCHelper.swift
//  SBC

import Foundation
import UIKit

enum CreateNewPasswordCells: Int {
    
    case cellTittle = 0
    case cellPassword
    case cellConfirmPassword
    case cellValidation
    case cellSubmitBtn
}

struct CreateNewPasswordModel {
    var email: String?
    var password: String?
    var confirmPassword: String?
}

struct CreatePassword {
    struct Images {
        let hidePassword = "hideeye"
        let showPassword = "showeye"
    }

    struct Messages {
        let emailValidation  =  localizedStringForKey(key: "Email_format_is_incorrect", "")
        let emptyPassword        = localizedStringForKey(key: "MSG_EMPTY_NEW_PASSWORD", "")
        let emptyPasswordConfirm = localizedStringForKey(key: "MSG_EMPTY_CONFIRM_PASSWORD", "")
        let passwordValidation = localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED", "")
    }

    struct Titles {
        let passwordPlaceholder = localizedStringForKey(key: "SIGNUP_ENTER_PASSWORD", "")
        let confirmPasswordPlaceholder = localizedStringForKey(key: "SIGN_UP_CONFIRM_PASSWORD_TEXT", "")
    }
}
