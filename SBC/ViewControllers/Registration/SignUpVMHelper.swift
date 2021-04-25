//
//  SignUpVMHelper.swift
//  SBC

import UIKit

enum SignupCells: Int {
    
    case cellTittle = 0
    case cellName
    case cellEmail
    case cellPassword
    case cellConfirmPassword
    case cellValidation
    case cellSubmitBtn
    case cellLoginBtn
}

enum TextFieldTag: Int {
    case name
    case email
    case password
    case confirmpassword
}

struct SignUpModel {
    var name: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var facebookId: String?
    var appleId: String?
}

struct Images {
    let hidePassword = "hideeye"
    let showPassword = "showeye"
}

struct Messages {
    let emptyName = localizedStringForKey(key: "MSG_EMPTY_Name", "")
    let emptyEmail = localizedStringForKey(key: "MSG_EMPTY_EMAIL", "")
    let emailValidation = localizedStringForKey(key: "Email_format_is_incorrect", "")
    let emptyPassword = localizedStringForKey(key: "MSG_EMPTY_NEW_PASSWORD", "")
    let emptyPasswordConfirm = localizedStringForKey(key: "MSG_EMPTY_CONFIRM_PASSWORD", "")
    let passwordValidation = localizedStringForKey(key: "MSG_PASSWORD_VALIDATION_FAILED", "")
}

struct Titles {
    let namePlaceHolder = localizedStringForKey(key: "NAME")
    let passwordPlaceholder = localizedStringForKey(key: "PASSWORD", "")
    let confirmPasswordPlaceholder = localizedStringForKey(key: "CONFIRM_PASSWORD", "")
    let emailAddressPlaceHolder = localizedStringForKey(key: "EMAIL_ADDRESS", "")
    let btnRegisterPlaceholder = localizedStringForKey(key: "REGISTER")
    let loginPlacholder = localizedStringForKey(key: "LOGIN")
    let tittleREGISTER_WITH_EMAIL = localizedStringForKey(key: "REGISTER_WITH_EMAIL")
    
}
