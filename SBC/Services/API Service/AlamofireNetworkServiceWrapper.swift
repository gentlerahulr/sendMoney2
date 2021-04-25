import Foundation
import Alamofire

typealias TupleVariable = (fileData: Data, fileName: String, mimeType: String)

enum EncodingType {
    case urlEncoding
    case jsonEncoding
}

//This protocol to define functions to communicate with network.
protocol NetworkAPIServiceProtocol {
    // swiftlint:disable:next function_parameter_count
    func performRequest<T: Decodable, E: Encodable>(endPoint: String, method: HTTPMethod,
                                                    requestObject: E?, headers: HTTPHeaders?, encodingType: EncodingType, decoder: JSONDecoder, completion: @escaping (Result<T, APIError>) -> Void)
    // swiftlint:disable:next function_parameter_count
    func performDownload(url: String, fileName: String, method: HTTPMethod,
                         parameters: [String: Any]?, headers: HTTPHeaders, uRLEncoding: URLEncoding, completion:@escaping (Bool) -> Void)
    func performUpload(urlString: String, params: [String: Any], completion: @escaping (Bool) -> Void)
    func getParameterEncoding(encodingType: EncodingType) -> ParameterEncoding
}

extension NetworkAPIServiceProtocol {
    func performRequest<T: Decodable, E: Encodable>(endPoint: String, method: HTTPMethod,
                                                    requestObject: E?, headers: HTTPHeaders?, encodingType: EncodingType, completion: @escaping (Result<T, APIError>) -> Void) {
        performRequest(endPoint: endPoint, method: method, requestObject: requestObject, headers: headers, encodingType: encodingType, decoder: JSONDecoder(), completion: completion)
    }
}

//This class is wrapper to communicate with Alamofire methods.
final class AlamofireNetworkServiceWrapper: NSObject, NetworkAPIServiceProtocol {
    
    static let sharedInstance: AlamofireNetworkServiceWrapper = AlamofireNetworkServiceWrapper()
    private var baseUrl: String?
    let evaluators = ["httpbin.org": PinnedCertificatesTrustEvaluator()]
    let sessionWithPinning: Session
    
    private override init() {
        sessionWithPinning = Session(
            serverTrustManager: ServerTrustManager(evaluators: evaluators)
        )
        // TODO: Set Base URL from Configuration
        let infoDictionary = Bundle.main.infoDictionary
        baseUrl = infoDictionary?["BASE_URL"] as? String
    }
    
    public func getBaseUrl() -> String? {
        return baseUrl
    }
    
    func getParameterEncoding(encodingType: EncodingType) -> ParameterEncoding {
        
        switch encodingType {
        case .urlEncoding:
            return URLEncoding.default
        case .jsonEncoding:
            return JSONEncoding.default
        }
    }
    
    //This function perform network data request and after completion will pass completion handler which contains Result object wich has Decodable object and APIError object.
    func performRequest<T: Decodable, E: Encodable>(endPoint: String, method: HTTPMethod = .get, requestObject: E?,
                                                    headers: HTTPHeaders? = nil, encodingType: EncodingType, decoder: JSONDecoder, completion: @escaping (Result<T, APIError>) -> Void) {
        let parameters = JsonHelper.encode(requestObject)
        let apiUrl: URLConvertible = {
            if let url = URL(string: endPoint), url.scheme != nil {
                return url
            } else {
                return (baseUrl ?? "") + endPoint
            }
        }()
        let request = AF.request(
            apiUrl,
            method: method,
            parameters: parameters,
            encoding: getParameterEncoding(encodingType: encodingType),
            headers: headers
        ).validate()
        request.responseData { response in
            if let token = response.response?.allHeaderFields["Authorization"] as? String {
                TokenManager.shared().updateToken(token: token)
            }
            
            if let status = response.response?.statusCode {
                debugPrint("Response - \(request.printedResponse())")
                if status == 401 {
                    TokenManager.shared().clearAllData()
                    DispatchQueue.main.async {
                        RootViewControllerRouter.setDashboardAsRootVC(animated: false)
                    }
                    return
                }
            }
        }
        
        request.responseCodable(T.self, decoder: decoder) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //This function make multipart data request and after completion will pass completion handler which contains boolean parameter to show success and failure of data.
    //-Parameters
    //-urlString: URL which handles multipart data.
    //-params: contains parameters which are required to perform multipart data.
    //  --TupleVariable: contains data, filename and MIMEType
    func performUpload(urlString: String, params: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let url = try? urlString.asURL() else {
            return
        }
        sessionWithPinning.upload(multipartFormData: { (multiFormData) in
            for (key, value) in params {
                if let data = value as? Data {
                    multiFormData.append(data, withName: key)
                } else if let tupleData = value as? TupleVariable {
                    multiFormData.append(tupleData.fileData,
                                         withName: key,
                                         fileName: tupleData.fileName,
                                         mimeType: tupleData.mimeType)
                }
            }
        }, to: url)
            .response { response in
                if response.error == nil && response.response?.statusCode == 200 {
                    completion(false)
                } else {
                    completion(false)
                }
        }
    }
    
    //This function make multipart data request and after completion will pass completion handler which contains boolean parameter to show success and failure of data.
    // swiftlint:disable:next function_parameter_count
    public func performDownload(url: String, fileName: String, method: HTTPMethod,
                                parameters: [String: Any]?, headers: HTTPHeaders, uRLEncoding: URLEncoding, completion: @escaping (Bool) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let apiUrl = (self.baseUrl ?? "") + url
        
        sessionWithPinning.download(apiUrl, method: method, to: destination).response { response in
            print(response)
            if response.error == nil && response.response?.statusCode == 200, response.fileURL?.path != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
