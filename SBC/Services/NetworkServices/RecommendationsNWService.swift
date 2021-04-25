//
//  RecommendationsNWService.swift
//  SBC
//

import Foundation

class RecommendationsNWService: BaseNetworkService, RecommendationsServiceProtocol {
    
    func getRecommendations(request: RecommendationsRequest, completion: @escaping RecommendationsCompletionHandler) {
        let endPoint = String(format: EndPoint.recommendations, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<RecommendationsResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
}
