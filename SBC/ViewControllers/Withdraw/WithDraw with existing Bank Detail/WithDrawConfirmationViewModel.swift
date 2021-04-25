//
//  WithDrawConfirmationViewModel.swift
//  SBC

import Foundation

protocol WithDrawConfirmationPassingDelegate: AnyObject {
    func transfermoneySucces(response: TransferMoneyResponse)
    func transfermoneyfailure(message: String)
    func exchangeRateSucces(response: ExchangeRateResponse)
    func failure(message: String)
}
    
protocol WithDrawConfirmationViewModelProtocol {
    var delegate: WithDrawConfirmationPassingDelegate? { get set }
    var exchangeRateResponse: ExchangeRateResponse? { get set }
    var withdrawRequest: WithdrawRequest? {get set}
    func getExchangeRate()
    func transferMoney(request: TransferMoneyRequest)
}

class WithDrawConfirmationViewModel: WithDrawConfirmationViewModelProtocol {
   weak var delegate: WithDrawConfirmationPassingDelegate?
    var topupRequest: TopUpRequest?
    var exchangeRateResponse: ExchangeRateResponse?
    var withdrawRequest: WithdrawRequest?
    var withdrawManager = WithDrawManager(dataStore: APIStore.instance)
    func getExchangeRate() {
        CommonUtil.sharedInstance.showLoader()
        withdrawManager.perfromExchangeRate(comletion: { result in
            switch result {
            case .success(let response):
                self.exchangeRateResponse = response
                self.delegate?.exchangeRateSucces(response: response)
            case .failure (let error):
                CommonUtil.sharedInstance.removeLoader()
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
