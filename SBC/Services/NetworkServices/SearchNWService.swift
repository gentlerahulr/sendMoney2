class SearchNWService: BaseNetworkService, SearchServiceProtocol {
    func getCuisineList(request: CuisinesRequest, completion: @escaping CuisinesCompletionHandler) {
        let endPoint = String(format: EndPoint.cuisines, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Cuisines, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    func getTrendingList(request: TrendingRequest, completion: @escaping TrendingsCompletionHandler) {
        let endPoint = String(format: EndPoint.suggested, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Trendings, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSuggestedList(request: SuggestedRequest, completion: @escaping TrendingsCompletionHandler) {
        let endPoint = String(format: EndPoint.trendings, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Trendings, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    //this must be refined when endpoint is available. For the sake of simplicity we assume now that we get venues back.
    func getSearchResult(request: SearchRequest, completion: @escaping SearchResultCompletionHandler) {
        let endPoint = String(format: EndPoint.search, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<SearchResults, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
}
