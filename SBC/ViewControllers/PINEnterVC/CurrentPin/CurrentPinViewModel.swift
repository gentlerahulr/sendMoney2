import Foundation

protocol CurrentPinDataPassingDelegate: AnyObject {
    func suceessHandler()
    func failureHandler(message: String)
}

protocol CurrentPinViewModelProtocol {
    var delegate: CurrentPinDataPassingDelegate? { get set }
    var mobileOTPType: MobileOTPType? { get set }
    func callValidateCurrentPinAPI(mpinRequest: MpinRequest)
}

class CurrentPinViewModel: CurrentPinViewModelProtocol {
    weak var delegate: CurrentPinDataPassingDelegate?
    let walletManager = WalletManager(dataStore: APIStore.instance)
    var mobileOTPType: MobileOTPType?
    
    func callValidateCurrentPinAPI(mpinRequest: MpinRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performValidateMPIN(request: mpinRequest) { (result: Result<ValidateMpinResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let model):
                self.delegate?.suceessHandler()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
}
