import Foundation

class CustomerNWService: BaseNetworkService, CustomerServiceProtocol {
   
    func performGetCardDetails(cardHashId: String, completion: @escaping CardDetailsCompletionHandler) {
        let endPoint = String(format: EndPoint.getCardDetails, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID, cardHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<Card, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetUnmaskCardDetail(cardHashId: String, completion: @escaping UnmaskCardDetailCompletionHandler) {
        let endPoint = String(format: EndPoint.getUnmaskCardDetail, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID, cardHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<UnmaskCardDetail, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetCardCVVDetail(cardHashId: String, completion: @escaping CardCVVDetailCompletionHandler) {
        let endPoint = String(format: EndPoint.getCardCVVDetail, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID, cardHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CardCVVDetail, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetCardDetailList(completion: @escaping CardDetailListCompletionHandler) {
        let endPoint = String(format: EndPoint.getCardDetailList, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CardDetailList, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetCardImageURLs(completion: @escaping CardImageURLsCompletionHandler) {
        let endPoint = String(format: EndPoint.getCardImages, Config.CLIENT_HASHID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CardImageURLs, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
}
