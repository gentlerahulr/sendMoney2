import Foundation
//Use struct default, change to class only when required. Conform to only single protocol Ecodable or Decodable as per use.
struct LoginRequest: Encodable {
    let deviceId: String
    let email: String
    let password: String
    let loginType: String
    let facebookId: String
    let appleId: String
    let clientHashId = "a4eddfd1-2e73-4412-a1c8-46f8f72aa14d"
}
