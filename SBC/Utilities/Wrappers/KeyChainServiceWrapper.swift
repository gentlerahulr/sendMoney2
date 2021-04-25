import Foundation
import SwiftKeychainWrapper

protocol KeyChainServiceWrapperProtocol {
    
    @discardableResult
    func set(value: String, forKey key: String) -> Bool
    
    func get(key: String) -> String?
    
    @discardableResult
    func delete(key: String) -> Bool
    
    var authToken: String? { get set }
    
}

class KeyChainServiceWrapper: KeyChainServiceWrapperProtocol {
    
    static let standard: KeyChainServiceWrapper =  KeyChainServiceWrapper()
    private let keyChain = KeychainWrapper.standard
    
    private init() {
    }
    
    @discardableResult
    func set(value: String, forKey key: String) -> Bool {
        
        return keyChain.set(value, forKey: key)
    }
    
    func get(key: String) -> String? {
        return keyChain.string(forKey: key)
    }
    
    @discardableResult
    func delete(key: String) -> Bool {
        return keyChain.removeObject(forKey: key)
    }
}

extension KeyChainServiceWrapper {
    
    var authToken: String? {
        get {
            return  KeyChainServiceWrapper.standard.get(key: SettingsKeys.authorization.rawValue)
        }
        set(newValue) {
            if newValue == nil {
                KeyChainServiceWrapper.standard.delete(key: SettingsKeys.authorization.rawValue)
            } else {
                KeyChainServiceWrapper.standard.set(value: newValue!, forKey: SettingsKeys.authorization.rawValue)
            }
        }
    }
    
    var appAuthToken: String? {
        get {
            return  KeyChainServiceWrapper.standard.get(key: SettingsKeys.appAuthToken.rawValue)
        }
        set(newValue) {
            if newValue == nil {
                KeyChainServiceWrapper.standard.delete(key: SettingsKeys.appAuthToken.rawValue)
            } else {
                KeyChainServiceWrapper.standard.set(value: newValue!, forKey: SettingsKeys.appAuthToken.rawValue)
            }
        }
    }
    
    var userHashId: String {
        get {
            return  KeyChainServiceWrapper.standard.get(key: SettingsKeys.userHashId.rawValue) ?? ""
        }
        set(newValue) {
            if newValue != userHashId {
                userEmail = ""
                loginWalletPassword = nil
                UserDefaults.standard.isWalletBiometricEnabled = false
                UserDefaults.standard.appConfigurationValues = nil
            }
            if newValue == "" {
                KeyChainServiceWrapper.standard.delete(key: SettingsKeys.userHashId.rawValue)
            } else {
                KeyChainServiceWrapper.standard.set(value: newValue, forKey: SettingsKeys.userHashId.rawValue)
            }
        }
    }
    
    var userEmail: String {
        get {
            return  KeyChainServiceWrapper.standard.get(key: SettingsKeys.userEmail.rawValue) ?? ""
        }
        set(newValue) {
            if newValue == "" {
                KeyChainServiceWrapper.standard.delete(key: SettingsKeys.userEmail.rawValue)
            } else {
                KeyChainServiceWrapper.standard.set(value: newValue, forKey: SettingsKeys.userEmail.rawValue)
            }
        }
    }
    var loginWalletPassword: String? {
        get {
            return  KeyChainServiceWrapper.standard.get(key: SettingsKeys.loginWalletPassword.rawValue)
        }
        set(newValue) {
            if  newValue == nil {
                KeyChainServiceWrapper.standard.delete(key: SettingsKeys.loginWalletPassword.rawValue)
            } else {
                KeyChainServiceWrapper.standard.set(value: newValue!, forKey: SettingsKeys.loginWalletPassword.rawValue)
            }
        }
    }
    
}
