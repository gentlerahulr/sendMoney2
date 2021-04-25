//
//  PaymentDetailViewModel.swift
//  SBC
//

import UIKit

enum TcCSourceType: Int {
    case creditCard = 0
    case bankAccount = 1
}

struct TransactionRequestResponse: Decodable {
    let systemReferenceNumber: String
    let sourceAmount: Double
    let sourceCurrencyCode: String
    let destinationAmount: Double
    let destinationCurrencyCode, status: String
    let paymentMethods: [PaymentMethod]
}

protocol PaymentDetailPassingDelegate: AnyObject {
    func topUpSucces(response: TopUpRequestResponse)
    func topUpFailure(message: String)
    func addCardSuccess(response: TopUpCardFundResponse)
    func transfermoneySucces(response: TransferMoneyResponse)
    func transfermoneyfailure(message: String)
    func exchangeRateSucces(response: ExchangeRateResponse)
    func failure(message: String)
}

protocol PaymentDetailViewModelProtocol {
    var delegate: PaymentDetailPassingDelegate? { get set }
    func performTopUpFromPayNow(request: TopUpFromPayNowRequest)
    func performAddPaymentFromCard(request: TopUpCardRequest)
    var topupRequest: TopUpRequest? { get set }
    var exchangeRateResponse: ExchangeRateResponse? { get set }
    var withdrawRequest: WithdrawRequest? {get set}
    func getExchangeRate()
    func transferMoney(request: TransferMoneyRequest)
}

class PaymentDetailViewModel: PaymentDetailViewModelProtocol {
    var exchangeRateResponse: ExchangeRateResponse?
    weak var delegate: PaymentDetailPassingDelegate?
    var topupManager = TopUpManager(dataStore: APIStore.instance)
    var topupRequest: TopUpRequest?
    var withdrawManager = WithDrawManager(dataStore: APIStore.instance)
    func performTopUpFromPayNow(request: TopUpFromPayNowRequest) {
        CommonUtil.sharedInstance.showLoader()
        topupManager.performTopUpFromPayNow(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.topUpSucces(response: response)
            case .failure( let error):
                self.delegate?.topUpFailure(message: error.localizedDescription)
            }
        })
    }
    
    func performAddPaymentFromCard(request: TopUpCardRequest) {
        CommonUtil.sharedInstance.showLoader()
        topupManager.performTopUpUsingCard(request: request) {(result: Result<TopUpCardFundResponse, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.addCardSuccess(response: response)
            case .failure( let error):
                self.delegate?.topUpFailure(message: error.localizedDescription)
            }
        }
    }
    
    var withdrawRequest: WithdrawRequest?
    
    func getExchangeRate() {
        CommonUtil.sharedInstance.showLoader()
        withdrawManager.perfromExchangeRate(comletion: { result in
            switch result {
            case .success(let response):
                self.exchangeRateResponse = response
                self.delegate?.exchangeRateSucces(response: response)
            case .failure (let error):
                self.delegate?.failure(message: error.localizedDescription)
                print(error)
            }
        })
    }
    
    func transferMoney(request: TransferMoneyRequest) {
        withdrawManager.performTransferMoney(request: request) { (result) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.transfermoneySucces(response: response)
            case .failure (let error):
                self.delegate?.transfermoneyfailure(message: error.localizedDescription)
                print(error)
            }
        }
    }
}
