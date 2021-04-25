import Foundation

// MARK: - MTTransaction

struct MTTransaction: Codable {
    let key: String
    let currency: String
    let amount: Double
    let date: Date
    let movement: Movement
    let description: String?
    let customFields: [CustomField]

    enum Movement: String, Codable {
        case debit, credit
    }

    enum CodingKeys: String, CodingKey {
        case key, currency, amount, date, movement, description
        case customFields = "custom_fields"
    }
}

// MARK: - MTTransactionCategory

struct MTTransactionCategory: Codable {
    let category: String
    let type: Type
    let parent: String?
    let locales: [Locale]?

    enum `Type`: String, Codable {
        case standard, custom
    }

    struct Locale: Codable {
        let language: String
        let value: String
        let label: String
    }
}

// MARK: - MTTransactionListRequest

struct MTTransactionListRequest: Encodable {
    let query: String?
    let count: Int = 30
}

// MARK: - MTTransactionDetailRequest

struct MTTransactionDetailRequest: Encodable {
    let key: String
}

// MARK: - MTSyncTransactionCustomFieldRequest

struct MTSyncTransactionCustomFieldRequest: Encodable {
    let key: String
    let customFields: [CustomField]

    enum CodingKeys: String, CodingKey {
        case key, customFields = "custom_fields"
    }
}

// MARK: - MTAcknowledgementResponse

struct MTAcknowledgementResponse: Decodable {
    struct Header: Decodable {
        let success: Bool
        let authenticated: Bool?
        let code: Int?
        let message: String?
    }
    let header: Header
}

// MARK: - MTPayloadResponse

struct MTPayloadResponse<T: Decodable>: Decodable {
    let payload: T
}

// MARK: - CustomField

struct CustomField: Codable {
    let name: String
    let value: CustomFieldValue
}

enum CustomFieldValue {
    case string(String), number(Double), boolean(Bool)
}

extension CustomFieldValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let numberValue = try? container.decode(Double.self) {
            self = .number(numberValue)
        } else if let booleanValue = try? container.decode(Bool.self) {
            self = .boolean(booleanValue)
        } else {
            self = .string(try container.decode(String.self))
        }
    }
}

extension CustomFieldValue: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .number(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

// MARK: - Keys for custom fields

struct CustomFieldKeys {
    static let customDescription = "custom_description"
    static let customNotes = "custom_notes"
}

// MARK: - extension for MTTransactionListResponse.Transaction

private let hashTagRegex = "#([A-Za-z0-9_]+)"

extension MTTransaction {
    var tags: [String] {
        guard
            let customDescription = customDescription,
            let regex = try? NSRegularExpression(pattern: hashTagRegex, options: [])
            else
        {
            return []
        }
        let matches = regex.matches(
            in: customDescription,
            options: [],
            range: NSRange(location: 0, length: customDescription.count)
        )
        return matches.compactMap { (result: NSTextCheckingResult) -> String? in
            guard let range = Range(result.range(at: 1), in: customDescription) else {
                return nil
            }
            return String(customDescription[range])
        }
    }

    var notes: String? {
        let customDescription = customFields.first { $0.name == CustomFieldKeys.customNotes }
        if case .string(let value) = customDescription?.value {
            return value
        } else {
            return nil
        }
    }

    private var customDescription: String? {
        let customDescription = customFields.first { $0.name == CustomFieldKeys.customDescription }
        if case .string(let value) = customDescription?.value {
            return value
        } else {
            return nil
        }
    }
}
