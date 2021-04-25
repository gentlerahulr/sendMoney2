import Foundation

struct AddCardResponse: Decodable {
    let cardHashId: String
    let cardActivationStatus: String
    let maskedCardNumber: String
}

struct Card: Decodable {
    let createdAt, updatedAt, cardHashId, cardType: String
    let cardStatus, maskedCardNumber, proxyNumber, logoId: String
    let plasticId, regionCode: String
    let blockReason, replacedOn: String?
    let issuanceMode, issuanceType: String
    let embossingLine1, embossingLine2: String?
    let firstName: String
    let middleName: String?
    let lastName, email, countryCode, mobile: String
    let demogOverridden: Bool
    
    var firstAndLastName: String {
        return "\(firstName) \(lastName)"
    }
    
}

struct UnmaskCardDetail: Decodable {
    let unMaskedCardNumber: String
}

struct CardCVVDetail: Decodable {
    let cvv: String
    let expiry: String
    var formattedCVV: String {
        return "CVV \(cvv.base64Decoded() ?? "")"
    }
    var formattedExpiry: String {
        guard let decodedExpiry = expiry.base64Decoded() else {
            return "EXP "
        }
        return "EXP \(decodedExpiry.suffix(2))/\(decodedExpiry.prefix(2))"
    }
}

struct CardDetailList: Decodable {
    let totalPages: Int
    let cards: [Card]
    let totalElements: Int
    
    private enum CodingKeys: String, CodingKey {
           case totalPages
           case cards = "content"
           case totalElements
       }
}

typealias CardImageURLs = [String: String]
