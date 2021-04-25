import Foundation

//Global function
func localizedStringForKey(key: String, _ comment: String = "") -> String {
    return LocalizationSystem.sharedLocalSystem().localizedStringForKey(key: key, comment: comment)
}

class LocalizationSystem: NSObject {
    
    static var sharedlocalSystem: LocalizationSystem?
    static var bundle: Bundle?
    
    class func sharedLocalSystem() -> LocalizationSystem {
        
        if sharedlocalSystem == nil {
            
            sharedlocalSystem = LocalizationSystem()
            sharedlocalSystem?.setLanguage(language: .ENGLISH)
        }
        return sharedlocalSystem!
    }
    
    public func localizedStringForKey(key: String, comment: String) -> String {
        
        var value = LocalizationSystem.bundle?.localizedString(forKey: key, value: comment, table: nil)
        
        if value == nil {
            
            value = key
        }
        return value!
    }
    
    private func setLanguage(language: UserLanguage) {
        
        var resource = "en"
        
        if language == .ENGLISH {
            resource = "en"
        }
        
        let path = Bundle.current.path(forResource: resource, ofType: "lproj")
        if path == nil {
            self.resetLocalization()
        } else {
            LocalizationSystem.bundle = Bundle.init(path: path!)
        }
    }
    
    private func getLanguage() -> String {
        
        let languages = UserDefaults.standard.object(forKey: "AppleLanguages")
        let preferredLang = languages
        return preferredLang as! String
    }
    
    private func resetLocalization() {
        LocalizationSystem.bundle = Bundle.current
    }
}

extension Bundle {
    fileprivate static var current: Bundle {
        Bundle(for: LocalizationSystem.self)
    }
}
