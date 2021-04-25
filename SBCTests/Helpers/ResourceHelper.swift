import Foundation

class ResourceHelper {

    class func data(forResource name: String, ext: String? = nil) -> Data? {
        guard let contentURL = Bundle(for: self).url(forResource: name, withExtension: ext) else {
            return nil
        }
        return try? Data(contentsOf: contentURL)
    }
}
