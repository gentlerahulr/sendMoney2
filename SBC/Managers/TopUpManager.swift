//
//  TopUpManager.swift
//  SBC

import Foundation

typealias GetListSaveCardCompletionHandler = (_ result: Result<SavedCardResponse, APIError>) -> Void
typealias TopUpCardCompletionHandler = (_ result: Result<TopUpCardFundResponse, APIError>) -> Void
typealias GetTransacUsingSystemRefCompletionHandler = (_ result: Result<TopUpCardTransactionResponse, APIError>) -> Void
typealias PayNowTopUpCompletionHandler = (_ result: Result<TopUpRequestResponse, APIError>) -> Void

class TopUpManager: BaseManager {
    
    func performTopUpFromPayNow(request: TopUpFromPayNowRequest, completion: @escaping PayNowTopUpCompletionHandler) {
        self.dataStore.topUpService.performTopUpFromPaynow(request: request) { (result: Result<TopUpRequestResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func performTopUpUsingCard(request: TopUpCardRequest, completion: @escaping TopUpCardCompletionHandler) {
        self.dataStore.topUpService.performTopUpUsingCard(request: request) { (result: Result<TopUpCardFundResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func performGetSavedCardList(customerHASHID: String, completion: @escaping GetListSaveCardCompletionHandler) {
        self.dataStore.topUpService.performGetSavedCardList(customerHASHID: customerHASHID) { (result: Result<SavedCardResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func performGetTransactionUsingSystemRefNo(systemReferanceNo: String, completion: @escaping GetTransacUsingSystemRefCompletionHandler) {
        self.dataStore.topUpService.performGetTransactionUsingSystemRefNo(systemReferanceNo: systemReferanceNo) { (result: Result<TopUpCardTransactionResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
