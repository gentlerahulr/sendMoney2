//
//  PasswordrecoveryHelper.swift
//  SBC
//

import Foundation

struct PasswordrecoveryModel {
       var email: String?
   }

enum PasswordRecoveryCells: Int {
    case cellTittle
    case cellEmail
    case cellProceddBtn
}

struct PasswordRecovery {
    
    struct Messages {
        let emptyEmail =  localizedStringForKey(key: "MSG_EMPTY_EMAIL", "")
        let emailValidation  =  localizedStringForKey(key: "Email_format_is_incorrect", "")
    }
    struct Titles {
        let emailAddressPlaceHolder = localizedStringForKey(key: "LOGIN_EMAIL_PLACEHOLDER_TEXT", "")
        
    }
}
