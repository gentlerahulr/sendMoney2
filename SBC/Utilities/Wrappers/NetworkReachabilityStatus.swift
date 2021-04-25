import Foundation
import Alamofire
class NetworkReachabilityStatus {
    class func isConnected() -> Bool {
        if let reachability = NetworkReachabilityManager(), reachability.isReachable == true {
            return true
        }
        return false
    }
}
