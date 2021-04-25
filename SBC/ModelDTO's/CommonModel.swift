import Foundation

struct CommonNotificationResponse: Decodable {
    let status: String?
    let message: String?
    let success: String?
}

//Using when we have to send api parameter as nil.
struct NilRequest: Encodable {
    
}
