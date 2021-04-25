//
//  TokenManager.swift
//  SBC
//

import Foundation
import Alamofire
import NetworkExtension

class TokenManager {
    fileprivate static var mInstance: TokenManager = TokenManager()
    fileprivate let tokenDBService = TokenDBManager()
    
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let device  = UIDevice.current.model
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                return "\("iOS") \(versionString)"
            }()
            return "\(executable)/\(appVersion) (\(device); \(osNameVersion))"
        }
        return ""
    }()
    
    fileprivate  init() { }
    
    static func shared() -> TokenManager {
        return mInstance
    }
    
    func getToken() -> String? {
        return tokenDBService.getToken()
    }
    
    public func clearAllData() { }
    
    // MARK: - Token Management
    func updateToken(token: String) {
        tokenDBService.setToken(token: token)
    }
    
    func getBasicAuthRequestHeader() -> HTTPHeaders {
        getRequestHeaders(isAuth: true)
    }
    
   func getRequestHeaders(isAuth: Bool = false) -> HTTPHeaders {
           var headers: HTTPHeaders  =   [
               "x-request-id": UIDevice.current.identifierForVendor?.uuidString ?? "",
               "Content-Type": "application/json"
           ]
           if !isAuth {
               headers["Authorization"] = getToken()
           }
           return headers
       }
    
    func getRequestCustomHeaders(isAuth: Bool = false) -> HTTPHeaders {
        var headers: HTTPHeaders  =   [
            "x-api-key": "",
            "x-client-name": "",
            "x-request-id": "",
            "Content-Type": ""
        ]
        if !isAuth {
            headers["Authorization"] = ""
        }
        return headers
    }
    
    func getWiFiAddress() -> String? {
        var address: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}
