//
//  StripeUIWebViewModel.swift
//  SBC

import Foundation

protocol StripeUIWebViewDataPassingDelegate: AnyObject {
    func failureWithError(message: String)
    func getTransactionSucces(response: TopUpCardTransactionResponse)
}

protocol StripeUIWebViewModelProtocol {
    var delegate: StripeUIWebViewDataPassingDelegate? { get set }
    var redirectURL: String? { get set }
    var topUpCardFundResponse: TopUpCardFundResponse? { get set }
    func getTransactionUsingSystemRefNo(systemReferanceNo: String)
}

class StripeUIWebViewModel: StripeUIWebViewModelProtocol {
    var topUpCardFundResponse: TopUpCardFundResponse?
    weak var delegate: StripeUIWebViewDataPassingDelegate?
    var redirectURL: String?
    let topUpManger = TopUpManager(dataStore: APIStore.instance)
    func getTransactionUsingSystemRefNo(systemReferanceNo: String) {
        CommonUtil.sharedInstance.showLoader()
        topUpManger.performGetTransactionUsingSystemRefNo(systemReferanceNo: systemReferanceNo, completion: { [weak self] result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let respose):
                self?.delegate?.getTransactionSucces(response: respose)
            case .failure( let error):
                self?.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
}
