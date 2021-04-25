import Foundation
import Alamofire

class MoneyThorNWService: BaseNetworkService {
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted({
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }())
        return decoder
    }()
}

extension MoneyThorNWService: MoneyThorServiceProtocol {
    func performGetTransactionList(
        request: MTTransactionListRequest,
        completion: @escaping GetTransactionListCompletionHandler
    ) {
        let endPoint = EndPoint.getTransactionList
        let decoder = jsonDecoder
        authenticateMoneyThor { authResult in
            switch authResult {
            case .success(let token):
                let headers = HTTPHeaders([
                    HTTPHeader(name: "Authorization", value: "Bearer \(token)")
                ])
                self.networkService.performRequest(
                    endPoint: endPoint,
                    method: .post,
                    requestObject: request,
                    headers: headers,
                    encodingType: .urlEncoding,
                    decoder: decoder
                ) { (result: Result<MTPayloadResponse<[MTTransaction]>, APIError>) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func performGetTransaction(
        request: MTTransactionDetailRequest,
        completion: @escaping GetTransactionCompletionHandler
    ) {
        let endPoint = EndPoint.getTransaction
        let decoder = jsonDecoder
        authenticateMoneyThor { authResult in
            switch authResult {
            case .success(let token):
                let headers = HTTPHeaders([
                    HTTPHeader(name: "Authorization", value: "Bearer \(token)")
                ])
                self.networkService.performRequest(
                    endPoint: endPoint,
                    method: .post,
                    requestObject: request,
                    headers: headers,
                    encodingType: .jsonEncoding,
                    decoder: decoder
                ) { (result: Result<MTPayloadResponse<MTTransaction>, APIError>) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func performGetTransactionCategories(completion: @escaping GetTransactionCategoriesCompletionHandler) {
        let endPoint = EndPoint.getTransactionCategories
        authenticateMoneyThor { authResult in
            switch authResult {
            case .success(let token):
                let headers = HTTPHeaders([
                    HTTPHeader(name: "Authorization", value: "Bearer \(token)")
                ])
                self.networkService.performRequest(
                    endPoint: endPoint,
                    method: .post,
                    requestObject: Empty.value,
                    headers: headers,
                    encodingType: .urlEncoding
                ) { (result: Result<MTPayloadResponse<[MTTransactionCategory]>, APIError>) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func performSyncTransactionCustomFields(
        request: MTSyncTransactionCustomFieldRequest,
        completion: @escaping UpdateTransactionCompletionHandler
    ) {
        let endPoint = EndPoint.syncTransactionCustomFields
        let decoder = jsonDecoder
        authenticateMoneyThor { authResult in
            switch authResult {
            case .success(let token):
                let headers = HTTPHeaders([
                    HTTPHeader(name: "Authorization", value: "Bearer \(token)")
                ])
                self.networkService.performRequest(
                    endPoint: endPoint,
                    method: .post,
                    requestObject: request,
                    headers: headers,
                    encodingType: .jsonEncoding,
                    decoder: decoder
                ) { (result: Result<MTAcknowledgementResponse, APIError>) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension MoneyThorNWService {
    // TODO: Remove and use standard authentication
    private func authenticateMoneyThor(completion: @escaping (Result<String, APIError>) -> Void) {
        guard var urlRequest = try? URLRequest(url: "https://prjphx.moneythor.com/auth", method: .post) else {
            completion(.failure(.badRequest(BadRequestError(title: "Bad URL", errors: [], code: ""))))
            return
        }
        urlRequest.httpBody = "cname=Hulk&password=m3rl10n$".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if (response as? HTTPURLResponse)?.statusCode == 200,
                let token = String(data: data ?? Data(), encoding: .utf8) {
                completion(.success(token))
            } else {
                completion(.failure(APIError(data: data, error: error)))
            }
        }
        task.resume()
    }
}
