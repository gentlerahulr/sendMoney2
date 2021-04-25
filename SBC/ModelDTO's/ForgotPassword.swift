import Foundation

struct ForgotPasswordRequest: Encodable {
    let email: String
}

struct ForgotPasswordResponse: Decodable {
    var message: String?
}
