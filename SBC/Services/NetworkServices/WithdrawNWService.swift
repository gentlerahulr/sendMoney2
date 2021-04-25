//
//  WithdrawNWService.swift
//  SBC
//

import Foundation

class WithdrawNWService: BaseNetworkService, WithdrawServiceProtocol {
    
    func performAddBenificiary(request: AddBenificiaryRequest, completion: @escaping AddBenifiCiaryCompletionHandler) {
        let endPoint = String(format: EndPoint.addBenificiary, Config.CLIENT_HASHID, CommonUtil.customerHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<AddBenificiaryResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetBenificiaryDetail(beneficiaryHashId: String, completion: @escaping BenifiCiaryDetailCompletionHandler) {
        let endPoint = String(format: EndPoint.getBenificiaryDetail, Config.CLIENT_HASHID, CommonUtil.customerHashID, beneficiaryHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<BenificiaryDetailsResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetBenifiCiaryList(completion: @escaping BenifiCiaryListCompletionHandler) {
        let endPoint = String(format: EndPoint.getBenificiaryList, Config.CLIENT_HASHID, CommonUtil.customerHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<SavedBeneficiaryResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetRoutingCode(beneficiaryHashId: String, routingCodeType1: String, routingCodeValue1: String, completion: @escaping RoutingCodeCompletionHandler) {
        let endPoint = String(format: EndPoint.getRoutingCode, Config.CLIENT_HASHID, CommonUtil.customerHashID, Config.DEFAULT_COUNTRY_CODE, routingCodeType1, routingCodeValue1)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<RoutingCodeResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func perfromExchangeRate(comletion: @escaping ExchangeRateCompletionHandler) {
        
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let params = "/api/v1/client/\(Config.CLIENT_HASHID)/customer/\(CommonUtil.customerHashID)/wallet/\(CommonUtil.walletHashID)/lockExchangeRate?destinationCurrency=\(String(describing: Config.DEFAULT_CURRENCY))&sourceCurrency=\(String(describing: Config.DEFAULT_CURRENCY))"
        guard let escapedString = params.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet) else { return }
        let url = "/nium-cards-platform/**?url=" + escapedString
        
        self.networkService.performRequest(endPoint: url, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ExchangeRateResponse, APIError>) in
            switch result {
            case .success(let model):
                comletion(.success(model))
            case .failure( let error):
                comletion(.failure(error))
            }
        }
    }
    
    func performTransferMoney(request: TransferMoneyRequest, completion: @escaping TransferMoneyCompletionHandler) {
        let endPoint = String(format: EndPoint.transferMoney, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<TransferMoneyResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performSearchBank(request: SearchBankRequest, completion: @escaping BankListCompletionHandler) {
        let endPoint = String(format: EndPoint.searchBank, Config.CLIENT_HASHID, CommonUtil.customerHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<SearchBankResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performValidateSchema(completion: @escaping ValidateSchema) {
        let endPoint = String(format: EndPoint.validateBeneSchema, Config.CLIENT_HASHID, CommonUtil.customerHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ValidationBeneSchema, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
}
