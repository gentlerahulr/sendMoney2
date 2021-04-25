import Foundation

typealias TrendingsCompletionHandler = (_ result: Result<Trendings, APIError>) -> Void
typealias CuisinesCompletionHandler = (_ result: Result<Cuisines, APIError>) -> Void
typealias SearchResultCompletionHandler = (_ result: Result<SearchResults, APIError>) -> Void

class SearchManager: BaseManager {
    func getTrendings(request: TrendingRequest, completion: @escaping TrendingsCompletionHandler) {
        self.dataStore.searchService.getTrendingList(request: request) { (result: Result<Trendings, APIError>) in
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
    func getCuisines(request: CuisinesRequest, completion: @escaping CuisinesCompletionHandler) {
        self.dataStore.searchService.getCuisineList(request: request) { (result: Result<Cuisines, APIError>) in
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
    
    func getSuggested(request: SuggestedRequest, completion: @escaping TrendingsCompletionHandler) {
        self.dataStore.searchService.getSuggestedList(request: request) { (result: Result<Trendings, APIError>) in
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
    
    //This is a first draft as service is currently not implemented on backend
    func searchForResults(request: SearchRequest, completion: @escaping SearchResultCompletionHandler) {
        self.dataStore.searchService.getSearchResult(request: request) { (result: Result<SearchResults, APIError>) in
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
