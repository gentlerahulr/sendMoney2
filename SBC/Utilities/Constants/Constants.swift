import Foundation
import UIKit

struct K {
    static let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static let Password_Recovery_Title = "Password recovery"
    static let Password_Recovery_Desc = "If the email that you entered is registered with ONZ, you will receive a verification code. If you can’t find it, please check your spam folder."
    static let Password_Recovery_Resend_Title = "Resend code "
    static let Verify_Email_Title = "Verify your email"
    static let Verify_Email_Desc = "Please enter the verification code that was emailed to you. If you can’t find it, please check your spam folder."
    static let Verify_Email_Resend_Title = "Resend verification email"
    static let Incorrect_OTP = "Incorrect OTP"
    static let Email_Already_Exist = "Email already exist"
    static let User_Not_Found = "User not found."
    static let Incorrect_Creds = "Incorrect username or password"
    static let Verification_Mobile_Tittle = localizedStringForKey(key: "VERIFY_VERIFIACTION_CODE")
    static let Verify_mobile_Desc = localizedStringForKey(key: "VERIFY_VERIFIACTION_CODE_DESC")
    static let Verify_mobile_Resend_Title = localizedStringForKey(key: "RESEND_CODE")
    static let Verify_UpdateMobile_desc = localizedStringForKey(key: "UPDATE.VERIFICATION.DESC")
    static let EMPTY = ""
    static let Review_Card_Payment = localizedStringForKey(key: "REVIEW_CARD_PAYMENT")
    static let Invalid_Card_Number = localizedStringForKey(key: "INVALID_CARD_NUMBER")
    static let Invalid_Card_Date = localizedStringForKey(key: "INVALID_CARD_DATE")
    static let Invalid_CVV = localizedStringForKey(key: "INVALID_CVV_NUMBER")
    static let Card_CVV_Info = localizedStringForKey(key: "CARD_CVV_INFO")
    static let Review_Withdraw_Info = localizedStringForKey(key: "REVIEW_WITHDRAW_INFO")
    static var defaultStaticAmountArray = ["$20", "$50", "$100", "$300"]
    static let defaultAmountFloat: Float = 00.00
    static let defaultAmountDouble: Double = 00.00
    static let defaultAmountString = "00.00"
    static let allowedFirstCharacterForCardNumberArray = ["4", "5"]
    static let defaultAPIDelay = 2
    static let defaultMaximumNumberAPIRetry = 3
}

struct CommonButton {
    static let loginButton = localizedStringForKey(key: "button.title.login")
    
}

struct NotificationMessage {
    static let passwordUpdateMessage = localizedStringForKey(key: "notification.password.update.message")
    static let mobileNoUpdateMessage =  localizedStringForKey(key: "notification.mobile.update.message")
}
