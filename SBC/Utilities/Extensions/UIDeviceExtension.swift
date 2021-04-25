//
//  UIDeviceExtension.swift
//  SBC
//

import Foundation
import LocalAuthentication
import UIKit

// MARK: - Extension to determine faceId and Touch Id
extension UIDevice {
    
    var deviceHasTouchId: Bool {
        var hasTouchId: Bool = false
        let context: LAContext = LAContext()
        hasTouchId = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return hasTouchId
    }
    
    var deviceHasFaceId: Bool {
        //if iOS 11 doesn't exist then FaceID doesn't either
        if #available(iOS 11.0, *) {
            let context = LAContext.init()
            var error: NSError?
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                if context.biometryType == LABiometryType.faceID {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return false
    }
    
    func isBiometricValid(onSuccess success:@escaping (Bool) -> Void) {
        if #available(iOS 11.0, *) {
            let context = LAContext.init()
            let localizedReason = (context.biometryType == LABiometryType.faceID) ? "Authenticate using Face ID" : "Authenticate using Touch ID"
            context.localizedCancelTitle = "Use Passcode"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (isSuccess, _) in
                success(isSuccess)
            }
            
        } else { success(false) }
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum DeviceType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var deviceType: DeviceType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
}
