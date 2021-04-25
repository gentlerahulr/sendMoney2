//
//  EnterPinViewModel.swift
//  SBC

import Foundation

protocol EnterPinDataPassingDelegate: AnyObject {
    
}

protocol EnterPinViewModelProtocol {
    var delegate: EnterPinDataPassingDelegate? { get set }
    var mobileOTPType: MobileOTPType? { get set }
    var title: String { get }
    var screenTitle: String? { get }
}

class EnterPinViewModel: BaseViewModel, EnterPinViewModelProtocol {
    weak var delegate: EnterPinDataPassingDelegate?
    var mobileOTPType: MobileOTPType?
    var title: String {
        if mobileOTPType == .updatePin {
            return localizedStringForKey(key: "update.pin.enter.new.pin.title")
        }
        return localizedStringForKey(key: "PLEASE_ENTER_SIX_DIGIT_PIN")
    }
    
    var screenTitle: String? {
        if mobileOTPType  == .updatePin {
            return localizedStringForKey(key: "update.pin.screen.title")
        }
        return nil
    }
    
    func callValidateCurrentPinAPI(pin: String) {
        
    }
    
}
