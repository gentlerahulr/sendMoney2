//
//  TokenDBManager.swift
//  SBC
//

import Foundation
import SwiftKeychainWrapper

enum SettingsKeys: String {
    case enableQuickOptionSet = "enableQuickOptionSet"
    case quickOptionLoignType = "quickOptionLoignType"
    case userHashId = "userHashId"
    case clientHashId = "clientHashId"
    case loginFlowComplete = "loginFlowComplete"
    case authorization = "token"
    case appAuthToken = "appAuthToken"
    case userEmail = "userEmail"
    case loginWalletPassword = "loginWalletPassword"
}

class TokenDBManager: NSObject {
  private var token: String?
    
    override init() {
        super.init()
        token = KeychainWrapper.standard.string(forKey: SettingsKeys.authorization.rawValue)
    }
    
    func getToken() -> String? {
        return token
    }
    
    func setToken(token: String?) {
        guard let tokenValue = token else {
            return
        }
        self.token = tokenValue
        if KeyChainServiceWrapper.standard.appAuthToken == nil {
            KeyChainServiceWrapper.standard.appAuthToken = tokenValue
        }
        KeychainWrapper.standard.set(tokenValue, forKey: SettingsKeys.authorization.rawValue)
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: SettingsKeys.authorization.rawValue)
        token = nil
    }
}
