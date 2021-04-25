import Alamofire
import Foundation

internal extension Alamofire.DataRequest {
    @discardableResult
    func printedResponse(_ function: String = #function, file: String = #file) -> Self {
        return responseData { response in
            print("""
            ------------
            ➡️ \(URL(fileURLWithPath: file).lastPathComponent), \(function),
            Headers: \(response.request?.allHTTPHeaderFields?.description ?? "none")
            Request: \(response.request?.description ?? "none")
                Request Body: \(response.request?.httpBody?.string() ?? "none")
                Error: \(String(describing: response.error ?? NoError().asAFError))
            Data: \(response.data?.string() ?? "none")
            ------------
            """)
        }
    }

    struct NoError: Error {}
}
