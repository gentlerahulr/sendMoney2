import Foundation
struct WalletRegisterRequest: Encodable {
    let countryCode: String?
    let mobile: String
}
struct WalletRegisterStatusResponse: Decodable {
    let isWalletRegistered: Bool
    let isMobileVerified: Bool
    let isPinSet: Bool
    let customerHashId: String?
    let walletHashId: String?
    let countryCode: String?
    let mobile: String?
    let email: String?
}

struct UpdateWalletRegisteredRequest: Encodable {
    let isWalletRegistered: Bool
    let customerHashId: String
    let walletHashId: String
}

struct UpdateWalletDataRequest: Encodable {
    let clientHashId: String?
    let clientName: String?
    let customerHashId: String?
    let walletHashId: String?
}

struct VerifyMobileForWalletRequest: Encodable {
    let deviceId: String?
    let otp: String?
}

struct MinimalCustomerDataResponse: Decodable {
    let customerHashId: String?
    let walletHashId: String?
    let kycStatus: String?
    let redirectUrl: String
}

struct MinimalCustomerDataRequest: Encodable {
    let email: String?
    let countryCode: String?
    let mobile: String?
    let customerHashId: String?
    let walletHashId: String?
}

struct GetWalletTnCResponse: Decodable {
    let name: String
    let versionId: String
    let description: String
    let createdAt: String
}
typealias WalletBalanceResponseArray = [WalletBalance]
// MARK: - GetwalletBalanceResponseElement
struct WalletBalance: Decodable {
    let curSymbol: String
    let balance: Double
}
struct AcceptWalletTnCRequest: Encodable {
    let accept: Bool
    let name: String?
    let versionId: String?
}
struct Customer: Decodable {
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let dateOfBirth: String?
    let email: String?
    let countryCode: String?
    let mobile: String?
    let customerHashId: String?
    let walletHashId: String?
    let billingAddress1: String?
    let billingAddress2: String?
    let billingCity: String?
    let billingLandmark: String?
    let billingState: String?
    let billingZipCode: String?
    let termsAndConditionAcceptanceFlag: Bool?
    let complianceStatus: String?
    let complianceRemarks: String?
    
    var formattedMobileNumber: String? {
        guard let mobileNumber = mobile else { return nil }
        return "+\(CommonUtil.countryCode) \(mobileNumber.grouping(every: 4, with: " "))"
    }
    
    var fullName: String {
        return "\(firstName ?? "") \(middleName ?? "") \(lastName ?? "")"
    }
    
    var fullBillingAddress: String {
        return "\(billingAddress1 ?? "") \(billingAddress2 ?? "") \(billingLandmark ?? "") \(billingCity ?? "") \(billingState ?? "") \(billingZipCode ?? "")"
    }
}
