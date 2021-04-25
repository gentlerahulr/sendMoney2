//
//  TNCForWalletViewModel.swift
//  SBC

import Foundation
import UIKit

protocol TNCForWalletPassingDelegate: AnyObject {
    func failureHandler(message: String)
    func walletSuccessHandler(response: GetWalletTnCResponse)
}

protocol TNCForWalletViewModelProtocol: AnyObject {
    var delegate: TNCForWalletPassingDelegate? { get set }
    var getWalletTncResponse: GetWalletTnCResponse? { get set }
    func callGetWalletTnC()
}

class TNCForWalletViewModel: TNCForWalletViewModelProtocol {
    weak var delegate: TNCForWalletPassingDelegate?
    var getWalletTncResponse: GetWalletTnCResponse?
    let walletManager = WalletManager(dataStore: APIStore.instance)
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
}
