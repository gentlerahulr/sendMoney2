import Foundation
@testable import ONZ

extension String {
    var localized: String {
        localizedStringForKey(key: self)
    }
}
