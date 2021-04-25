import Foundation

struct ONZConfiguration: Decodable {
    let apiCallThreshold, apiCallNumber: String
    let linkedCards: [LinkedCard]
    let minWalletLimit, maxWalletLimit: String
    let staticValues: [String]

    enum CodingKeys: String, CodingKey {
        case apiCallThreshold = "api-call-threshold"
        case apiCallNumber = "api-call-number"
        case linkedCards = "linked_cards"
        case minWalletLimit = "min-wallet-limit"
        case maxWalletLimit = "max-wallet-limit"
        case staticValues = "static-values"
    }
}

// MARK: - LinkedCard
struct LinkedCard: Decodable {
    let cardBackground: CardBackground?
    let plasticID: String?

    enum CodingKeys: String, CodingKey {
        case cardBackground = "card_background"
        case plasticID = "plastic_id"
    }
}

// MARK: - CardBackground
struct CardBackground: Decodable {
    let cardBgURL: String?
    let cardGradientColor: String?

    enum CodingKeys: String, CodingKey {
        case cardBgURL = "card_bg_url"
        case cardGradientColor = "card_gradient_color"
    }
}
