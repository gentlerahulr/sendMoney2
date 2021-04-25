//
//  AppConstant.swift
//  SBC
//

//

import Foundation
import UIKit

struct ImageConstants {
    static let IMG_BACK   = "img_back"
    static let IMG_BACK_WHITE = "icon-back-white"
    static let hidePassword = "hideEye"
    static let showPassword = "showEye"
    static let clear_Btn = "clearBtn"
    static let Oops   = "Oops!"
    static let SuccessWithdraw = "SuccessWithdraw"
    static let SuccessTopUp = "Top-up-success"
    
}

struct ColorHex {
    static let ThemeDarkBlue = "172553"
    static let ThemeRed = "FF001F"
    static let ThemeLightBlue = "676f89"
    static let ThemeNeonBlue = "00F5E4"
    static let ThemeNeonBlue2 = "bffdf8"
    static let ThemeNeonYellowTint2 = "fffcc8"
    static let ThemeNeonGreen = "5BFA28"
    static let ThemeDarkBlueTint1 = "676F89"
    static let ThemeDarkBlueTint2 = "C5C8D4"
    static let ThemeDarkBlueTint3 = "F0F1F5"
}

struct Config {
    static let DEFAULT_MOBILE_LIMIT = 8
    static let DEFAULT_COUNTRY_CODE = "65"
    static let DEFAULT_COUNTRY_CODE_INTITIAL = "SG"
    static let countryDict: [String: String] = [ "65": "SG", "91": "IN"]
    static let CLIENT_HASHID = "a4eddfd1-2e73-4412-a1c8-46f8f72aa14d"
    static let CLIENT_NAME = "SCB"
    static let MAX_TOPUP_AMOUNT: Float = 1000.0
    static let MIN_TOPUP_AMOUNT: Float = 1.0
    static let TRANSACTION_NOTES_MAX_CHARACTER_COUNT = 100
    static let DEFAULT_CURRENCY = "SGD"
    
}

let htmlContent = """
<html><body><p>Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.

Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.

Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.

Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.
</p></body></html>
"""

class CommonUtil: NSObject {
    static let sharedInstance = CommonUtil()
    let loadingView: LoaderViewController
    static var userEmail = ""
    static var userMobile = ""
    static var customerHashID = ""
    static var walletHashID = ""
    static var countryCode = ""
    static var redirectUrl = ""
    
    private override init() {
        self.loadingView  = LoaderViewController(nibName: "LoaderViewController", bundle: nil)
    }
    
    func showLoader() {
        self.loadingView.view.frame = UIApplication.shared.keyWindow?.frame ?? CGRect.zero
        UIApplication.shared.keyWindow?.addSubview(self.loadingView.view)
    }
    
    func removeLoader() {
        self.loadingView.view.removeFromSuperview()
    }
}
