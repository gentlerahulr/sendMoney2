import Foundation

struct OTPModel {
    let title: String?
    let desc: String?
    let contactInfo: String?
    let resendTitle: String?
    let verificationError: String = localizedStringForKey(key: "otp_incorrect_error_message")
    var mobileOTPType: MobileOTPType?
    var shouldSecureText: Bool = false
}

protocol OTPVerificationDataPassingDelegate: AnyObject {
    func performOTPVerificationSuccessAction()
    func performOTPVerificationFailureAction(message: String)
    func getOTPSuccess()
    func getOTPFailure(message: String)
    func forgotFailureHandler(message: String)
    func forgotSuccessHandler()
    func getWalletOTPSucces()
    func getWalletOTPFailure(message: String)
    func verifyMobileSuccessAction()
    func verifyMobileFailureAction(message: String)
    func updateMobileNoSuccessAction()
    func updateMobileNoFailureAction(message: String)
}

protocol OTPVerificationViewModelProtocol: AnyObject {
    var delegate: OTPVerificationDataPassingDelegate? { get  set }
    var model: OTPModel? { get set }
    var lblTitleConfig: LabelConfig { get }
    var lblDescConfig: LabelConfig { get }
    var lblContactConfig: LabelConfig { get }
    var lblErrorConfig: LabelConfig { get }
    var btnResendConfig: ButtonConfig { get }
    func requestForOTPGeneration(request: OTPGenerationRequest)
    func requestForOTPVerification(request: OTPVerificationRequest)
    func requestForPasswordApi(request: ForgotPasswordRequest)
    func requestOTPforWallet(request: OTPGenerationRequest)
    func requestVerifyMobileForWallet(request: VerifyMobileForWalletRequest)
    func requestOTPforMobile(request: OTPGenerationRequest)
    func requestForUpdateCustomerMobileNo(request: WalletRegisterRequest)
    func requestOTPforUpdateMobile(request: OTPGenerationRequest)
}

class OTPVerificationViewModel: OTPVerificationViewModelProtocol {

    weak var delegate: OTPVerificationDataPassingDelegate?
    var model: OTPModel?
    let userManager = UserManager(dataStore: APIStore.instance)
    let walletManager = WalletManager(dataStore: APIStore.instance)
    
    // MARK: - UI Config
    var lblTitleConfig: LabelConfig {
        return LabelConfig.getBoldLabelConfig(text: model?.title)
    }
       
    var lblDescConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: model?.desc)
    }
       
    var lblContactConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: model?.contactInfo)
    }
       
    var lblErrorConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: model?.verificationError, textColor: .themeRed, textAlignment: .center)
    }
    
    var btnResendConfig: ButtonConfig {
        return ButtonConfig.getRegularButtonConfig(titleText: model?.resendTitle)
    }
    
    func requestForOTPGeneration(request: OTPGenerationRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.performGetOTP(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.getOTPSuccess()
            case .failure(let error):
                self.delegate?.performOTPVerificationFailureAction(message: error.localizedDescription)
            }
        })
    }
    
    func requestForOTPVerification(request: OTPVerificationRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.performVerifyOTP(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.performOTPVerificationSuccessAction()
            case .failure(let error):
                self.delegate?.performOTPVerificationFailureAction(message: error.localizedDescription)
            }
        })
    }
    
    func requestForPasswordApi(request: ForgotPasswordRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.performForgotPassword(request: request) { (result: Result<ForgotPasswordResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.forgotSuccessHandler()
            case .failure( let error):
                self.delegate?.forgotFailureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func requestOTPforWallet(request: OTPGenerationRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performOTPgenerationForMobile(for: .updatePin, request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.getWalletOTPSucces()
            case .failure( let error):
                self.delegate?.getWalletOTPFailure(message: error.localizedDescription)
                
            }
        })
    }
    
    func requestVerifyMobileForWallet(request: VerifyMobileForWalletRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performVerifyMobile(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.verifyMobileSuccessAction()
            case .failure( let error):
                self.delegate?.verifyMobileFailureAction(message: error.localizedDescription)
            }
        })
    }
    
    func requestOTPforMobile(request: OTPGenerationRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performOTPgenerationForMobile(for: .otpVerification, request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.getWalletOTPSucces()
            case .failure( let error):
                self.delegate?.getWalletOTPFailure(message: error.localizedDescription)
                
            }
        })
    }
    
    func requestForUpdateCustomerMobileNo(request: WalletRegisterRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performUpdateCustomerMobile(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.updateMobileNoSuccessAction()
            case .failure( let error):
                self.delegate?.updateMobileNoFailureAction(message: error.localizedDescription)
            }
        })
    }
    
    func requestOTPforUpdateMobile(request: OTPGenerationRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performOTPgenerationForMobile(for: .updateMobileNo, request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.getWalletOTPSucces()
            case .failure( let error):
                self.delegate?.getWalletOTPFailure(message: error.localizedDescription)
                
            }
        })
    }
}
