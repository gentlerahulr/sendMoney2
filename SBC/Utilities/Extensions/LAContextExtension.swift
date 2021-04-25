import UIKit
import LocalAuthentication

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
        case biometryLockout
    }
    
    var biometricType: BiometricType {
        var error: NSError?
        
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            if error?.code == LAError.biometryLockout.rawValue {
                return .biometryLockout
            }
            return .none
        }
        
        if error?.code == LAError.biometryLockout.rawValue {
            return .biometryLockout
        }
        
        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                fatalError()
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    /// This function authenticates WithvBiometric
    /// - Parameter button: button to enable
    class func authenticationWithBiometric(fallbackTitle: String, viewController: UIViewController, completion: @escaping (_ result: Bool) -> Void) {
        let localAuthenticationContext = LAContext()
        if localAuthenticationContext.biometricType == .biometryLockout {
            let ac = UIAlertController(title: localizedStringForKey(key: "alert.biometric.enable.title"), message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: localizedStringForKey(key: "button.title.ok"), style: .default)
            ac.addAction(okAction)
            viewController.present(ac, animated: true, completion: nil)
            return
        }
        
        var isVerified = false
        localAuthenticationContext.localizedFallbackTitle = fallbackTitle
        var authorizationError: NSError?
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedStringForKey(key: "biometrics_fallBackTitle")) { success, _ in
                isVerified = success
                completion(isVerified)
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            debugPrint(error)
            completion(isVerified)
        }
    }
}
