//
//  RecommendationsManager.swift
//  SBC
//

import Foundation

typealias RecommendationsCompletionHandler = (_ result: Result<RecommendationsResponse, APIError>) -> Void

class RecommendationsManager: BaseManager {
    
    func getRecommendations(request: RecommendationsRequest, completion: @escaping RecommendationsCompletionHandler) {
        self.dataStore.recommendationsService.getRecommendations(request: request) { (result: Result<RecommendationsResponse, APIError>) in
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
