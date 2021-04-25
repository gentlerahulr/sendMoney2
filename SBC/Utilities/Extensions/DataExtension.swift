import Foundation

extension Data {
    func string() -> String {
        return String(decoding: self, as: UTF8.self)
    }
}
