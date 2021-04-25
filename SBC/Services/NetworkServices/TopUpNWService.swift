//
//  TopUpNWService.swift
//  SBC
//

import Foundation
class TopUpNWService: BaseNetworkService, TopUpServiceProtocol {
    
    func performGetSavedCardList(customerHASHID: String, completion: @escaping GetListSaveCardCompletionHandler) {
        let endPoint = String(format: EndPoint.getTopupSavedCards, Config.CLIENT_HASHID, customerHASHID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<SavedCardResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performTopUpUsingCard(request: TopUpCardRequest, completion: @escaping TopUpCardCompletionHandler) {
        let endPoint = String(format: EndPoint.topUpFromCard, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<TopUpCardFundResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetTransactionUsingSystemRefNo(systemReferanceNo: String, completion: @escaping GetTransacUsingSystemRefCompletionHandler) {
        let endPoint = String(format: EndPoint.getTransactionTopUpCard, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID, systemReferanceNo)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<TopUpCardTransactionResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performTopUpFromPaynow(request: TopUpFromPayNowRequest, completion: @escaping PayNowTopUpCompletionHandler) {
        let endPoint = String(format: EndPoint.topUpFromPaynow, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<TopUpRequestResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
}
