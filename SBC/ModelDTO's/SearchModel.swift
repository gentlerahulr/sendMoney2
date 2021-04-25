struct Trendings: Decodable {
    var data: [String]?
}

struct Cuisines: Decodable {
    let data: [Cuisine]?
    let limit: Int?
    let count: Int?
    let nextPageToken: String?
}

struct Cuisine: Decodable {
    let name: String?
    let imageUrl: String?
    let id: String
    let isLiked: Bool?
}

struct TrendingRequest: Codable {}
struct SuggestedRequest: Codable {}

struct CuisinesRequest: Codable {
    let featured: Bool
    let limit: Int?
    let pageToken: String?
}

struct SearchRequest: Codable{
    let limit: Int?
    let pageToken: String?
    let term: String?
    let type: String?
    let cuisine: String?
    let sort: String?
}


struct SearchResults: Decodable {
    let data: [SearchResult]
    let limit, count: Int
    let nextPageToken: String
}

struct SearchResult: Decodable {
    let id, name, type: String
    let rating: Double?
    let priceBracket: Int?
    let cuisines: [Cuisine]?
    let area: String?
    let imageURL: String?
    let placeCount, likeCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, type, rating, priceBracket, cuisines, area
        case imageURL = "imageUrl"
        case placeCount, likeCount
    }
}
