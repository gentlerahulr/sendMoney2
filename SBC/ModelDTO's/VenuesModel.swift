import Foundation

struct VenuesRequest: Codable {
}

struct VenueRequest: Codable {
    let id: String
}

struct UpdateVenueRequest: Codable {
    let caption: String?
}

struct ToggleLikeVenueRequest: Codable {
    let id: String
}
struct ToggleLikeVenueResponse: Codable {
    let data: Bool
}

struct Venues: Decodable, Equatable {
    let nextPageToken: String?
    let limit: Int
    let count: Int
    var data: [Venue]
    let updated: Date?
    
    private enum CodingKeys: String, CodingKey {
        case nextPageToken
        case limit
        case count
        case data
        case updated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nextPageToken = try? container.decode(String.self, forKey: .nextPageToken)
        count = try container.decode(Int.self, forKey: .count)
        limit = try container.decode(Int.self, forKey: .limit)
        if let date = try? container.decode(String.self, forKey: .updated) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            updated = dateFormatter.date(from: date)
        } else {
            updated = nil
        }
        data = try container.decode([Venue].self, forKey: .data)
        
    }
}

struct Venue: Decodable, Equatable {
    let id: String
    let name: String
    var caption: String?
    var description: String?
    var googlePlacesId: String?
    var address: String?
    let imageUrl: String?
    let badgeUrl: String?
    let priceBracket: Int
    let starRating: Double?
    let reviewCount: Int?
    let category: String?
    let area: String?
    let openingHours: String?
    let menuUrl: String?
    var likeCount: Int
    let phoneNumber: String?
    let facebookUrl: String?
    let instagramUrl: String?
    let websiteUrl: String?
    let bookingUrl: String?
    let hasDeals: Bool?
    var isLiked: Bool
    let deals: Deals?
    let reviews: Reviews?
    let hashtags: [String]?
    var featuredPlaylists: Playlists?
    var similarVenues: Venues?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case caption
        case description
        case googlePlacesId
        case address
        case imageUrl
        case badgeUrl
        case priceBracket
        case starRating
        case reviewCount
        case category
        case area
        case openingHours
        case menuUrl
        case likeCount
        case phoneNumber
        case facebookUrl
        case instagramUrl
        case websiteUrl
        case bookingUrl
        case hasDeals
        case isLiked
        case deals
        case reviews
        case hashtags
        case featuredPlaylists
        case similarVenues
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data) {
            id = try nestedContainer.decode(String.self, forKey: .id)
            name = try nestedContainer.decode(String.self, forKey: .name)
            caption = try? nestedContainer.decode(String.self, forKey: .caption)
            description = try? nestedContainer.decode(String.self, forKey: .description)
            googlePlacesId = try? nestedContainer.decode(String.self, forKey: .googlePlacesId)
            address = try? nestedContainer.decode(String.self, forKey: .address)
            imageUrl = try? nestedContainer.decode(String.self, forKey: .imageUrl)
            badgeUrl = try? nestedContainer.decode(String.self, forKey: .badgeUrl)
            category = try? nestedContainer.decode(String.self, forKey: .category)
            area = try? nestedContainer.decode(String.self, forKey: .area)
            openingHours = try? nestedContainer.decode(String.self, forKey: .openingHours)
            priceBracket = try nestedContainer.decode(Int.self, forKey: .priceBracket)
            reviewCount = try? nestedContainer.decode(Int.self, forKey: .reviewCount)
            starRating = try? nestedContainer.decode(Double.self, forKey: .starRating)
            menuUrl = try? nestedContainer.decode(String.self, forKey: .menuUrl)
            likeCount = try nestedContainer.decode(Int.self, forKey: .likeCount)
            phoneNumber = try? nestedContainer.decode(String.self, forKey: .phoneNumber)
            facebookUrl = try? nestedContainer.decode(String.self, forKey: .facebookUrl)
            instagramUrl = try? nestedContainer.decode(String.self, forKey: .instagramUrl)
            websiteUrl = try? nestedContainer.decode(String.self, forKey: .websiteUrl)
            bookingUrl = try? nestedContainer.decode(String.self, forKey: .bookingUrl)
            hasDeals = try? nestedContainer.decode(Bool.self, forKey: .hasDeals)
            isLiked = try nestedContainer.decode(Bool.self, forKey: .isLiked)
            deals = try? nestedContainer.decode(Deals.self, forKey: .deals)
            reviews = try? nestedContainer.decode(Reviews.self, forKey: .reviews)
            hashtags = try? nestedContainer.decode([String].self, forKey: .hashtags)
            featuredPlaylists = try? nestedContainer.decode(Playlists.self, forKey: .featuredPlaylists)
            similarVenues = try? nestedContainer.decode(Venues.self, forKey: .similarVenues)
        } else {
            id = try container.decode(String.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            caption = try? container.decode(String.self, forKey: .caption)
            description = try? container.decode(String.self, forKey: .description)
            googlePlacesId = try? container.decode(String.self, forKey: .googlePlacesId)
            address = try? container.decode(String.self, forKey: .address)
            imageUrl = try? container.decode(String.self, forKey: .imageUrl)
            badgeUrl = try? container.decode(String.self, forKey: .badgeUrl)
            category = try? container.decode(String.self, forKey: .category)
            area = try? container.decode(String.self, forKey: .area)
            openingHours = try? container.decode(String.self, forKey: .openingHours)
            priceBracket = try container.decode(Int.self, forKey: .priceBracket)
            starRating = try? container.decode(Double.self, forKey: .starRating)
            reviewCount = try? container.decode(Int.self, forKey: .reviewCount)
            menuUrl = try? container.decode(String.self, forKey: .menuUrl)
            likeCount = try container.decode(Int.self, forKey: .likeCount)
            phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
            facebookUrl = try? container.decode(String.self, forKey: .facebookUrl)
            instagramUrl = try? container.decode(String.self, forKey: .instagramUrl)
            websiteUrl = try? container.decode(String.self, forKey: .websiteUrl)
            bookingUrl = try? container.decode(String.self, forKey: .bookingUrl)
            hasDeals = try container.decode(Bool.self, forKey: .hasDeals)
            isLiked = try container.decode(Bool.self, forKey: .isLiked)
            deals = try? container.decode(Deals.self, forKey: .deals)
            reviews = try? container.decode(Reviews.self, forKey: .reviews)
            hashtags = try? container.decode([String].self, forKey: .hashtags)
            featuredPlaylists = try? container.decode(Playlists.self, forKey: .featuredPlaylists)
            similarVenues = try? container.decode(Venues.self, forKey: .similarVenues)
        }
    }
}

struct Deals: Decodable, Equatable {
    let nextPageToken: String?
    let limit: Int
    let count: Int
    var data: [Deal]?
}

struct Deal: Decodable, Equatable {
    let id: String
    let name: String
    let expiryDate: Date?
    let type: String
    let providerName: String?
    let providerIconUrl: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case expiryDate
        case type
        case providerName
        case providerIconUrl
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        if let date = try? container.decode(String.self, forKey: .expiryDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let newDate = dateFormatter.date(from: date) {
                expiryDate = newDate
            } else {
                expiryDate = nil
            }
        } else {
            expiryDate = nil
        }
        url = try? container.decode(String.self, forKey: .url)
        providerName = try? container.decode(String.self, forKey: .providerName)
        providerIconUrl = try? container.decode(String.self, forKey: .providerIconUrl)
        
    }
}

struct Reviews: Decodable, Equatable {
    let nextPageToken: String?
    let limit: Int
    let count: Int
    var data: [Review]?
}

struct Review: Decodable, Equatable {
    let id: String
    let source: String
    let rating: Double
    let updated: Date?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case source
        case rating
        case updated
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(String.self, forKey: .source)
        rating = try container.decode(Double.self, forKey: .rating)
        if let date = try? container.decode(String.self, forKey: .updated) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            updated = dateFormatter.date(from: date)
        } else {
            updated = nil
        }
        url = try? container.decode(String.self, forKey: .url)
        
    }
}
