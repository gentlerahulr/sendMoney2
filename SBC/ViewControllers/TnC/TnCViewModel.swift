//
//  TnCViewModel.swift
//  SBC
//

import UIKit

protocol TnCDataPassingDelegate: AnyObject {
    func failureHandler(message: String)
    func successHandler()
    func walletSuccessHandler(response: GetWalletTnCResponse)
    func updatewalletDataSuccess()
}

protocol TnCViewModelProtocol: AnyObject {
    var delegate: TnCDataPassingDelegate? { get set }
    var isWalletTnC: Bool { get set }
    var redirectUrl: String? { get set }
    func callAcceptWalletTnC()
    func callUpdateTnCStatusAPI(request: UpdateTnCStatusRequest)
    func callAddCoustomerWithMinimalData(request: MinimalCustomerDataRequest)
    var getWalletTncResponse: GetWalletTnCResponse? { get set }
    func callGetWalletTnC()
    var labelTnCTitleConfig: LabelConfig { get }
    var labelAcceptConfig: LabelConfig { get }
    
}

class TnCViewModel: TnCViewModelProtocol {
    weak var delegate: TnCDataPassingDelegate?
    let userManager = UserManager(dataStore: APIStore.instance)
    let walletManager = WalletManager(dataStore: APIStore.instance)
    var redirectUrl: String?
    
    var labelAcceptConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: localizedStringForKey(key: "tnc.accept.label"), fontSize: 14)
    }
    
    var getWalletTncResponse: GetWalletTnCResponse?
    
    var labelTnCTitleConfig: LabelConfig {
        return LabelConfig.getBoldLabelConfig(text: localizedStringForKey(key: "tnc.title.label"))
    }
    var isWalletTnC: Bool = false
    func callUpdateTnCStatusAPI(request: UpdateTnCStatusRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.updateTnCStatus(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.successHandler()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func callGetWalletTnC() {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performGetWalletTnC { (result) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.getWalletTncResponse = response
                self.delegate?.walletSuccessHandler(response: response)
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func callAcceptWalletTnC() {
        CommonUtil.sharedInstance.showLoader()
        let request = AcceptWalletTnCRequest(accept: true, name: getWalletTncResponse?.name, versionId: getWalletTncResponse?.versionId)
        walletManager.performAcceptTnC(request: request) { (result) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                let request = UpdateWalletDataRequest(clientHashId: Config.CLIENT_HASHID, clientName: Config.CLIENT_NAME, customerHashId: CommonUtil.customerHashID, walletHashId: CommonUtil.walletHashID)
                self.callUpdateWalletData(request: request)
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func callAddCoustomerWithMinimalData(request: MinimalCustomerDataRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performAddCustomerWithMinimalCustomerData(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                CommonUtil.customerHashID = response.customerHashId ?? ""
                CommonUtil.walletHashID = response.walletHashId ?? ""
                self.redirectUrl = response.redirectUrl
                self.callAcceptWalletTnC()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        })
    }
    
    func callUpdateWalletData(request: UpdateWalletDataRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performUpdateWalletData(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.updatewalletDataSuccess()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        })
    }
}
