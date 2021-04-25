import Foundation

extension UserDefaults {
    struct Keys {
        // MARK: - Constants
        static let isLoggedIn = "isLoggedIn"
        static let isWalletBiometricEnabled = "isWalletBiometricEnabled"
        static let Appple_USER_IDENTIFIER = "appleUserIdentifier"
        static let appStaticAmount = "appStaticAmount"
        static let appConfiguration = "appConfiguration"
        static let lastDateCuisinesUpdated = "lastDateCuisinesUpdated"
        static let recentSearches = "recentSearches"
    }
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isLoggedIn)
        }
        set(newValue) {
            if newValue == nil {
                removeObject(forKey: UserDefaults.Keys.isLoggedIn)
            } else {
                UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.isLoggedIn)
            }
        }
    }
    
    //flag to check if user have apple signed in with identifier
    var dAppleUserIdentifier: String {
        get {
            var value = ""
            if UserDefaults.standard.value(forKey: UserDefaults.Keys.Appple_USER_IDENTIFIER) != nil {
                value = UserDefaults.standard.value(forKey: UserDefaults.Keys.Appple_USER_IDENTIFIER) as! String
            }
            return value
        }
        
        set(value) {
            UserDefaults.standard.setValue(value, forKey: UserDefaults.Keys.Appple_USER_IDENTIFIER)
        }
    }
    
    var isWalletBiometricEnabled: Bool {
        get {
            var value = false
            if UserDefaults.standard.value(forKey: UserDefaults.Keys.isWalletBiometricEnabled) != nil {
                value = UserDefaults.standard.value(forKey: UserDefaults.Keys.isWalletBiometricEnabled) as! Bool
            }
            return value
        }
        
        set(value) {
            UserDefaults.standard.setValue(value, forKey: UserDefaults.Keys.isWalletBiometricEnabled)
        }
    }
    
    var lastDateCuisinesUpdated: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaults.Keys.lastDateCuisinesUpdated) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.lastDateCuisinesUpdated)
            
        }
    }
    
    func updateLastDateCuisinesUpdated() {
        UserDefaults.standard.setValue(Date(), forKey: UserDefaults.Keys.lastDateCuisinesUpdated)
        UserDefaults.standard.synchronize()
    }
    
    var needsUpdatingCuisines: Bool {
        if let lastDate = lastDateCuisinesUpdated {
            if let diff = Calendar.current.dateComponents([.hour], from: lastDate, to: Date()).hour, diff > 48 {
                return true
            }
            return false
        } else {
            return true
        }
    }
    
    var recentSearches: [String] {
        get {
            return UserDefaults.standard.array(forKey: UserDefaults.Keys.recentSearches) as? [String] ?? []
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.recentSearches)
        }
    }
    
    func addSearchToRecent(text: String) {
        var recent = recentSearches
        if recent.count == 5 {
            recent.popLast()
        }
        recent.insert(text, at: 0)
        recentSearches = recent
    }
    
    func removeSearchAt(index: Int) {
        var recent = recentSearches
        if recent.count > index {
            recent.remove(at: index)
        }
        recentSearches = recent
    }
    
    var appConfigurationValues: ONZConfiguration? {
        get {
            guard let decoded  = UserDefaults.standard.data(forKey: Keys.appConfiguration) else {
                return nil
            }
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? ONZConfiguration
        }
        set(newValue) {
            if newValue == nil {
                removeObject(forKey: UserDefaults.Keys.appConfiguration)
            } else {
                let encodedData: Data? = try? NSKeyedArchiver.archivedData(withRootObject: newValue!, requiringSecureCoding: true)
                UserDefaults.standard.set(encodedData, forKey: Keys.appConfiguration)
            }
        }
    }
    
    var maxWalletAmount: Float {
        return appConfigurationValues?.maxWalletLimit.toFloat() ?? Config.MAX_TOPUP_AMOUNT
    }
    
    var minWalletAmount: Float {
        return appConfigurationValues?.minWalletLimit.toFloat() ?? Config.MIN_TOPUP_AMOUNT
    }
    
    var apiDelay: Int {
        return appConfigurationValues?.apiCallThreshold.int() ?? K.defaultAPIDelay
    }
    var maximumNumberAPIRetry: Int {
        return appConfigurationValues?.apiCallNumber.int() ?? K.defaultMaximumNumberAPIRetry
    }
}
