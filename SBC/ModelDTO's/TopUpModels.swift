//
//  TopUpModels.swift
//  SBC

import Foundation

struct TopUpFromPayNowRequest: Encodable {
    let fundingChannel: String
    let amount: String
    let pocketName: String
    let sourceCurrencyCode: String
    let destinationCurrencyCode: String
}

// MARK: - TopUpPaynow
struct TopUpRequestResponse: Decodable {
    let systemReferenceNumber: String
    let sourceAmount: Double
    let sourceCurrencyCode: String
    let destinationAmount: Double
    let destinationCurrencyCode, status: String
    let paymentMethods: [PaymentMethod]
}

// MARK: - PaymentMethod
struct PaymentMethod: Decodable {
    let bankName: String?
    let type: String
    let accountNumber, accountName, qrCode, uen: String?

    enum CodingKeys: String, CodingKey {
        case bankName, type, accountNumber, accountName, qrCode
        case uen = "UEN"
    }
}

// MARK: - TopUpCard

struct BankCard: Decodable, Equatable {
    let fundingInstrumentID, clientHashID, customerHashID, walletHashID: String?
    let cardHolderName, maskCardNumber: String?
    let cardType: String?
    let cardCurrency: String?
    let cardNetwork: String?
    let cardBankName: String?
    let saved, threeDSecureUsage: Bool
    let status, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case fundingInstrumentID = "fundingInstrumentId"
        case clientHashID = "clientHashId"
        case customerHashID = "customerHashId"
        case walletHashID = "walletHashId"
        case cardHolderName, maskCardNumber, cardType, cardCurrency, cardNetwork, cardBankName, saved, threeDSecureUsage, status, createdAt, updatedAt
    }
}

typealias SavedCardResponse = [BankCard]

struct TopUpCardRequest: Encodable {
    let amount: String
    var sourceCurrencyCode: String = "SGD"
    var destinationCurrencyCode: String = "SGD"
    var fundingInstrumentId: String
    var fundingInstrumentHolderName: String?
    var fundingInstrumentSecurityNumber: String?
    var fundingInstrumentNumber: String?
    var fundingInstrumentExpiry: String?
    var fundingChannel: String = "CARD"
    var save: Bool
}

struct TopUpExistingCardRequest: Encodable {
    let amount: Float
    let sourceCurrencyCode: String
    let destinationCurrencyCode: String
    let fundingInstrumentId: String
    let fundingInstrumentSecurityNumber: String
    let fundingChannel: String
    let save: Bool
}

struct TopUpCardFundResponse: Decodable {
    let systemReferenceNumber: String
    let sourceAmount: Float
    let sourceCurrencyCode: String
    let destinationAmount: Float
    let destinationCurrencyCode: String
    let status: String
    let paymentMethods: [String]
    let returnUrl: String
}

struct TopUpCardTransactionResponse: Decodable {
    let totalPages: Int
    let content: [TopupTransactionContent]
    let totalElements: Int
}

struct TopupTransactionContent: Decodable {
    let transactionType: String?
    let status: String?
    let settlementStatus: String?
    let processingCode: String?
    let transactionCurrencyCode: String?
    let cardTransactionAmount: Double
    let billingCurrencyCode: String?
    let billingAmount: Double
    let authCurrencyCode: String?
    let authAmount: Double
    let effectiveAuthAmount: Double
    let previousBalance: Double
    let currentWithHoldingBalance: Double
    let dateOfTransaction: String?
    let debit: Bool
    let cardHashID: String?
    let maskedCardNumber: String?
    let mcc: String?
    let merchantID: String?
    let merchantName: String?
    let merchantCity: String?
    let merchantCountry: String?
    let acquirerCountryCode: String?
    let acquiringInstitutionCode: String?
    let posConditionCode: String?
    let posEntryCapabilityCode: String?
    let billingReplacementAmount: Double
    let transactionReplacementAmount: Double
    let authCode: String?
    let originalAuthorizationCode: String?
    let systemTraceAuditNumber: String?
    let retrievalReferenceNumber: String?
    let settlementAmount: Double
    let terminalID: String?
    let rhaTransactionId: String?
    let partnerReferenceNumber: String?
    let comments: String?
    let labels: Labels?
    let createdAt: String?
    let updatedAt: String?
}

struct Labels: Codable {
    let partnerReferenceNumber, paymentID: String?

    enum CodingKeys: String, CodingKey {
        case partnerReferenceNumber
        case paymentID = "paymentId"
    }
}
