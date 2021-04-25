import Foundation

struct ResetPasswordRequest: Encodable {
    let deviceId: String
    let password: String
    let email: String
}
