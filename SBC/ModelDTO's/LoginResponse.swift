import Foundation
//Use struct default, change to class only when required. Conform to only single protocol Ecodable or Decodable as per use.
struct LoginResponse: Decodable {
    let userHashId: String
    let isEmailVerified: Bool
    let tncStatus: Bool
}
