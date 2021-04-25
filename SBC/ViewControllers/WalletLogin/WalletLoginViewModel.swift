import Foundation
import LocalAuthentication

protocol WalletLoginDataPassignDelegate: AnyObject {
    func validateMpinFailureHandler(message: String)
    func validateMpinSuccessHandler()
}

protocol WalletLoginViewModelProtocol {
    var delegate: WalletLoginDataPassignDelegate? { get set }
    var isBiometricEnabled: Bool { get  }
    var buttonUseBiometricsConfig: ButtonConfig { get }
    func validateMPin(request: MpinRequest)
}

class WalletLoginViewModel: WalletLoginViewModelProtocol {
    
    weak var delegate: WalletLoginDataPassignDelegate?
    
    let manager = WalletManager(dataStore: APIStore.instance)
    var isBiometricEnabled: Bool {
        if biometrciType == .none {
            return false
        }
        return UserDefaults.standard.isWalletBiometricEnabled
    }
    var buttonUseBiometricsConfig: ButtonConfig {
        return ButtonConfig.getRegularButtonConfig(titleText: localizedStringForKey(key: "button.title.use_biometrics"))
    }
    private var biometrciType: LAContext.BiometricType {
        return LAContext().biometricType
    }
    
    func validateMPin(request: MpinRequest) {
        CommonUtil.sharedInstance.showLoader()
        manager.performValidateMPIN(request: request) { (result: Result<ValidateMpinResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.validateMpinSuccessHandler()
            case .failure( let error):
                self.delegate?.validateMpinFailureHandler(message: error.localizedDescription)
            }
        }
    }
}
