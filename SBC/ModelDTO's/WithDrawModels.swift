//
//  WithDrawModels.swift
//  SBC
//

import Foundation

// MARK: - BenificiaryDetailsResponse
struct BenificiaryDetailsResponse: Decodable {
    let beneficiaryDetail: BeneficiaryDetail
    let payoutDetail: PayoutDetail
}

// MARK: - RoutingCodeResponse
struct RoutingCodeResponse: Decodable {
    let requestID, timestamp: String
    let data: [BankData]
}

// MARK: - Datum
struct BankData: Decodable {
    let bankName, bankCode, ifsc, branchName: String
    let state, city, countryCode: String
}

// MARK: - ExchangeRateResponse
struct ExchangeRateResponse: Decodable {
    let fxHoldID, sourceCurrency, destinationCurrency, fxRate: String?
    let holdExpiryAt: String?
    let auditID: Int

    enum CodingKeys: String, CodingKey {
        case fxHoldID = "fx_hold_id"
        case sourceCurrency = "source_currency"
        case destinationCurrency = "destination_currency"
        case fxRate = "fx_rate"
        case auditID = "audit_id"
        case holdExpiryAt = "hold_expiry_at"
    }

}
// MARK: - TransferMoneyResponse
struct TransferMoneyResponse: Decodable {
    let message, paymentID, systemReferenceNumber: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case paymentID = "payment_id"
        case systemReferenceNumber = "system_reference_number"
    }
}

struct AddBenificiaryRequest: Encodable {
    let beneficiaryDetail: BeneficiaryDetail
    let payoutDetail: PayoutDetail
}

struct Beneficiary: Decodable, Equatable {
    let beneficiaryDetail: BeneficiaryDetail
    let payoutDetail: PayoutDetail
    
}

// MARK: - BeneficiaryDetail

struct BeneficiaryDetail: Decodable, Equatable, Encodable {
    let beneficiaryHashID, name, contactNumber, accountType: String?
    let email, relationship, address, countryCode: String?
    let state, city, postcode: String?
    
    enum CodingKeys: String, CodingKey {
        case beneficiaryHashID = "beneficiary_hash_id"
        case name
        case contactNumber = "contact_number"
        case accountType = "account_type"
        case email, relationship, address
        case countryCode = "country_code"
        case state, city, postcode
    }
    
}

// MARK: - PayoutDetail

struct PayoutDetail: Decodable, Equatable, Encodable {
    
    let payoutHashID, countryCode, destinationCurrency, bankName: String?
    let accountType, accountNumber, payoutMethod, routingCodeType1: String?
    let routingCodeValue1: String?
    
    enum CodingKeys: String, CodingKey {
        case payoutHashID = "payout_hash_id"
        case countryCode = "country_code"
        case destinationCurrency = "destination_currency"
        case payoutMethod = "payout_method"
        case accountType = "account_type"
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case routingCodeType1 = "routing_code_type_1"
        case routingCodeValue1 = "routing_code_value_1"
    }
}
typealias SavedBeneficiaryResponse = [Beneficiary]

struct SearchBankRequest: Encodable {
    let country_code: String = "SG"
    let currency_code: String = "SGD"
    let payout_method: String = "LOCAL"
    let routing_code_type: String = "SWIFT"
    let search_key: String = "bank_name"
    let search_value: String
}

struct SearchBankResponse: Codable {
    let requestID, timestamp: String
    let data: [Bank]

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case timestamp, data
    }
}

struct Bank: Codable {
    let routingCodeValue: [String]
    let bankName: String

    enum CodingKeys: String, CodingKey {
        case routingCodeValue = "routing_code_value"
        case bankName = "bank_name"
    }
}

// MARK: - AddBenificiaryResponse
struct AddBenificiaryResponse: Codable {
    let data: BeneDetail
}

// MARK: - BeneClass
struct BeneDetail: Codable {
    let id, beneficiaryGroupName, clientID, clientLegalEntity: String
    let beneficiaryAccountType: String
    let payout: Payout

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case beneficiaryGroupName = "beneficiary_group_name"
        case clientID = "client_id"
        case clientLegalEntity = "client_legal_entity"
        case beneficiaryAccountType = "beneficiary_account_type"
        case payout
    }
}

// MARK: - Payout
struct Payout: Codable {
    let id, destinationCurrency, beneficiaryName, beneficiaryCountryCode: String
    let destinationCountry, beneficiaryBankName, beneficiaryBankAccountType, beneficiaryAccountNumber: String
    let routingCodeType1, routingCodeValue1, beneficiaryGroup, clientID: String
    let payoutMethod: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case destinationCurrency = "destination_currency"
        case beneficiaryName = "beneficiary_name"
        case beneficiaryCountryCode = "beneficiary_country_code"
        case destinationCountry = "destination_country"
        case beneficiaryBankName = "beneficiary_bank_name"
        case beneficiaryBankAccountType = "beneficiary_bank_account_type"
        case beneficiaryAccountNumber = "beneficiary_account_number"
        case routingCodeType1 = "routing_code_type_1"
        case routingCodeValue1 = "routing_code_value_1"
        case beneficiaryGroup = "beneficiary_group"
        case clientID = "client_id"
        case payoutMethod = "payout_method"
    }
}

struct TransferMoneyRequest: Encodable {
    let beneficiary: BeneficiaryRequest
    let payout: PayoutRequest
}
struct BeneficiaryRequest: Encodable {
    let id: String
}

struct PayoutRequest: Encodable {
    let audit_id: Int
    let payout_id: String
    let source_amount: String
}

// MARK: - ValidationSchema
struct ValidationBeneSchema: Decodable {
    let requestID, timestamp: String
    let data: [ValidationBeneSchemaData]

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case timestamp, data
    }
}

// MARK: - Datum
struct ValidationBeneSchemaData: Decodable {
    let schema: String?
    let id, type, title: String?
    let datumRequired: [String]?
    let properties: [String: ValidationBeneSchemaProperty]?
    let datumIf: ValidationBeneSchmaIf?
    let then: ValidationBeneSchemaThen?

    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id = "$id"
        case type, title
        case datumRequired = "required"
        case properties
        case datumIf = "if"
        case then
    }
}

// MARK: - If
struct ValidationBeneSchmaIf: Decodable {
    let properties: Properties?
    let ifRequired: [String]?

    enum CodingKeys: String, CodingKey {
        case properties
        case ifRequired = "required"
    }
}

// MARK: - Properties
struct Properties: Decodable {
    let clientLegalEntity: ClientLegalEntity

    enum CodingKeys: String, CodingKey {
        case clientLegalEntity = "client_legal_entity"
    }
}

// MARK: - ClientLegalEntity
struct ClientLegalEntity: Decodable {
    let const: String
}

// MARK: - Property
struct ValidationBeneSchemaProperty: Decodable {
    let id: String
    let type: TypeEnum
    let title: String
    let pattern: String?
    let errorMessage: String
    let propertyEnum: [String]?
    let maxLength: Int?
    let const: String?
    let ignoreLookup: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case type, title, pattern, errorMessage
        case propertyEnum = "enum"
        case maxLength, const, ignoreLookup
    }
}

enum TypeEnum: String, Decodable {
    case string = "string"
}

// MARK: - Then
struct ValidationBeneSchemaThen: Decodable {
    let thenRequired: [String]

    enum CodingKeys: String, CodingKey {
        case thenRequired = "required"
    }
}
