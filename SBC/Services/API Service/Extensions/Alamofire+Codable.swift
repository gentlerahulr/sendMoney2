//
//  Alamofire+Codable.swift
//  SBC
//

import Alamofire

internal extension Alamofire.DataRequest {
//    #if DEBUG
    @discardableResult
    func responseCodable<T: Decodable>(
        file: String = #file, line: Int = #line, function: String = #function,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Swift.Result<T, APIError>) -> Void
    ) -> Alamofire.DataRequest {
        return self.responseCodable(file: file, line: line, function: function, T.self, decoder: decoder, completion: completion)
    }

    @discardableResult
    func responseCodable<T: Decodable>(
        file: String = #file, line: Int = #line, function: String = #function,
        _ type: T.Type,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Swift.Result<T, APIError>) -> Void
    ) -> Alamofire.DataRequest {
        return self.responseData { dataResponse in
            if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201, let data = dataResponse.value {
                do {
                    completion(.success(try decoder.decode(type, from: data)))
                } catch {
                    completion(.failure(.parse(.init(error, file: file, line: line, function: function))))
                }
            } else {
                completion(.failure(APIError(data: dataResponse.data, error: dataResponse.error)))
            }
        }
    }
}
