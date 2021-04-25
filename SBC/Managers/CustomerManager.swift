import Foundation

typealias CustomerDetailsCompletionHandler = (_ result: Result<Customer, APIError>) -> Void
typealias CardDetailsCompletionHandler = (_ result: Result<Card, APIError>) -> Void
typealias UnmaskCardDetailCompletionHandler = (_ result: Result<UnmaskCardDetail, APIError>) -> Void
typealias CardCVVDetailCompletionHandler = (_ result: Result<CardCVVDetail, APIError>) -> Void
typealias CardDetailListCompletionHandler = (_ result: Result<CardDetailList, APIError>) -> Void
typealias CardImageURLsCompletionHandler = (_ result: Result<CardImageURLs, APIError>) -> Void

class CustomerManager: BaseManager {
   
    func getCustomerDetails(customerHashId: String, completion: @escaping CustomerDetailsCompletionHandler) {
        self.dataStore.walletService.performGetCustomerData(customerHASHID: customerHashId) { (result: Result<Customer, APIError>) in
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
    
    func getCardDetails(cardHashId: String, completion: @escaping CardDetailsCompletionHandler) {
        self.dataStore.customerService.performGetCardDetails(cardHashId: cardHashId) { (result: Result<Card, APIError>) in
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
    func getUnmaskCardDetail(cardHashId: String, completion: @escaping UnmaskCardDetailCompletionHandler) {
        self.dataStore.customerService.performGetUnmaskCardDetail(cardHashId: cardHashId) { (result: Result<UnmaskCardDetail, APIError>) in
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
    func getCardCVVdetails(cardHashId: String, completion: @escaping CardCVVDetailCompletionHandler) {
        self.dataStore.customerService.performGetCardCVVDetail(cardHashId: cardHashId) { (result: Result<CardCVVDetail, APIError>) in
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
    func getCardDetailList(completion: @escaping CardDetailListCompletionHandler) {
        self.dataStore.customerService.performGetCardDetailList { (result: Result<CardDetailList, APIError>) in
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
    
    func getCardImageURLs(completion: @escaping CardImageURLsCompletionHandler) {
        self.dataStore.customerService.performGetCardImageURLs { (result: Result<CardImageURLs, APIError>) in
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
