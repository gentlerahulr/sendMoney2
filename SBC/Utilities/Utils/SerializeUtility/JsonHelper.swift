//
//  JsonHelper.swift
//  SBC

import Foundation

class JsonHelper {
    static func getData<T: Decodable>(fileName: String?, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonDecoder = JSONDecoder()
            let model =  try jsonDecoder.decode(T.self, from: jsonData)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
    
    static func getJsonData<T: Decodable>(fileName: String?, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName!)
            
            do {
                let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                let model =  try jsonDecoder.decode(T.self, from: jsonData)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }
    }

    class func encode<T>(_ value: T?) -> [String: Any]? where T: Encodable {
        guard let objValue = value, !(value is NilRequest) else {
            return nil
        }
        do {
            let data = try JSONEncoder().encode(objValue)
            var params = try JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments) as! [String: Any]
            //Logger.d("Encoding \(T.self) to params : \(params)")
            let keysToRemove = params.keys.filter {
                if params[$0] == nil ||  $0 == "requestEndPoint" {
                    return true
                }
                return false
            }
            for key in keysToRemove {
                params.removeValue(forKey: key)
            }
            return params
        } catch {
            debugPrint("Couldn't encode \(T.self):\n\(error)")
        }
        return nil
    }
}
