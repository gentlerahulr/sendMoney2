//
//  CardPaymentViewModel.swift
//  SBC
//

import UIKit

protocol CardPaymentPassingDelegate: AnyObject {
    func addCardSucces(response: TopUpCardFundResponse)
    func addCardFailure(message: String)
}

protocol CardPaymentViewModelProtocol {
    var delegate: CardPaymentPassingDelegate? { get set }
    func performAddCard(request: TopUpCardRequest)
    var request: TopUpRequest? { get set }
}

class CardPaymentViewModel: CardPaymentViewModelProtocol {
    
    var request: TopUpRequest?
    weak var delegate: CardPaymentPassingDelegate?
    var topupManager = TopUpManager(dataStore: APIStore.instance)
    
    func performAddCard(request: TopUpCardRequest) {
        CommonUtil.sharedInstance.showLoader()
        topupManager.performTopUpUsingCard(request: request) {(result: Result<TopUpCardFundResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.addCardSucces(response: response)
            case .failure( let error):
                self.delegate?.addCardFailure(message: error.localizedDescription)
            }
        }
    }
}
