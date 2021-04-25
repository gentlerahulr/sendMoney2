//
//  ConfomPinViewModel.swift
//  SBC

import Foundation
import LocalAuthentication

struct ConfomPinModel {
    let setPin: String?
    var title: String
    var screenTitle: String?
    let mobileOTPType: MobileOTPType?
}

protocol ConfomPinPassingDelegate: AnyObject {
    func confirmSuccess()
    func confirmFailure(message: String)
}

protocol ConfomPinViewModelProtocol: AnyObject {
    var delegate: ConfomPinPassingDelegate? { get  set }
    var model: ConfomPinModel? { get set }
    var biometrciType: LAContext.BiometricType { get }
    func requestCreatePin(request: MpinRequest)
}

class ConfomPinViewModel: ConfomPinViewModelProtocol {
    weak var delegate: ConfomPinPassingDelegate?
    var model: ConfomPinModel?
    let walletManager = WalletManager(dataStore: APIStore.instance)
    
    var biometrciType: LAContext.BiometricType {
        return LAContext().biometricType
    }
    
    func requestCreatePin(request: MpinRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performCreateMPIN(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.confirmSuccess()
            case .failure( let error):
                self.delegate?.confirmFailure(message: error.localizedDescription)
                
            }
        })
        
    }
}
