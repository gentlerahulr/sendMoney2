import Foundation

enum MobileOTPType {
    case registerWallet
    case forgotPin
    case updatePin
    case updateMobileNo
    case otpVerification
}
struct OTPGenerationRequest: Encodable {
    let email: String?
    let mobile: String?
    let countryCode: String?
}
struct OTPVerificationRequest: Encodable {
    let deviceId: String?
    let otp: String?
    let otpType: String?
    let email: String?
}

struct OTPResponse: Decodable {
    let status: String?
    let message: String?
}
