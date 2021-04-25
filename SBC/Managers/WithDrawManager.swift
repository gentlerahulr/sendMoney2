//
//  WithDrawManager.swift
//  SBC
//

import Foundation

typealias AddBenifiCiaryCompletionHandler = (_ result: Result<AddBenificiaryResponse, APIError>) -> Void
typealias BenifiCiaryDetailCompletionHandler = (_ result: Result<BenificiaryDetailsResponse, APIError>) -> Void
typealias BenifiCiaryListCompletionHandler = (_ result: Result<SavedBeneficiaryResponse, APIError>) -> Void
typealias RoutingCodeCompletionHandler = (_ result: Result<RoutingCodeResponse, APIError>) -> Void
typealias ExchangeRateCompletionHandler = (_ result: Result<ExchangeRateResponse, APIError>) -> Void
typealias TransferMoneyCompletionHandler = (_ result: Result<TransferMoneyResponse, APIError>) -> Void
typealias BankListCompletionHandler = (_ result: Result<SearchBankResponse, APIError>) -> Void
typealias ValidateSchema = (_ result: Result<ValidationBeneSchema, APIError>) -> Void

class WithDrawManager: BaseManager {
    
    func performAddBenificiary(request: AddBenificiaryRequest, completion: @escaping AddBenifiCiaryCompletionHandler) {
        self.dataStore.withdrawService.performAddBenificiary(request: request) { (result: Result<AddBenificiaryResponse, APIError>) in
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
    
    func performGetBenificiaryDetail(beneficiaryHashId: String, completion: @escaping BenifiCiaryDetailCompletionHandler ) {
        
        self.dataStore.withdrawService.performGetBenificiaryDetail(beneficiaryHashId: beneficiaryHashId) { (result: Result<BenificiaryDetailsResponse, APIError>) in
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
    
    func performGetBenifiCiaryList(completion: @escaping BenifiCiaryListCompletionHandler) {
        self.dataStore.withdrawService.performGetBenifiCiaryList { (result: Result<SavedBeneficiaryResponse, APIError>) in
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
    
    func performGetRoutingCode(beneficiaryHashId: String, routingCodeType1: String, routingCodeValue1: String, completion: @escaping RoutingCodeCompletionHandler) {
        self.dataStore.withdrawService.performGetRoutingCode(beneficiaryHashId: beneficiaryHashId, routingCodeType1: routingCodeType1, routingCodeValue1: routingCodeValue1) { (result: Result<RoutingCodeResponse, APIError>) in
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
    
    func perfromExchangeRate(comletion: @escaping ExchangeRateCompletionHandler) {
        self.dataStore.withdrawService.perfromExchangeRate { (result: Result<ExchangeRateResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    comletion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    comletion(.failure(error))
                }
            }
        }
    }
    
    func performTransferMoney(request: TransferMoneyRequest, completion: @escaping TransferMoneyCompletionHandler) {
        self.dataStore.withdrawService.performTransferMoney(request: request) { (result: Result<TransferMoneyResponse, APIError>) in
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
    
    func performSeachBank(request: SearchBankRequest, completion: @escaping BankListCompletionHandler) {
        self.dataStore.withdrawService.performSearchBank(request: request) { (result: Result<SearchBankResponse, APIError>) in
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
    
    func performValidateSchema(completion: @escaping ValidateSchema) {
        self.dataStore.withdrawService.performValidateSchema { (result: Result<ValidationBeneSchema, APIError>) in
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
