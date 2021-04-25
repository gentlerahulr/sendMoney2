import Foundation
struct MpinRequest: Encodable {
    let mpin: String
}

struct ValidateMpinResponse: Decodable {
    let clientHashId: String
    let customerHashId: String
    let walletHashId: String
}
