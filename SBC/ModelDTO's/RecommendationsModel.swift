//
//  RecommendationsModel.swift
//  SBC
//

import Foundation

struct RecommendationsList: Decodable {
    var recommendations: [Recommendation]
    let type: String
    let title: String
}

struct RecommendationsResponse: Decodable {
    var data: [RecommendationsList]
}

struct Recommendation: Decodable {
    let id: String
    let title: String?
    var likeCount: Int
    let placeCount: Int?
    var isLiked, hasDeals: Bool
    let hasRequestedVenue: Bool?
    let name: String?
    let imageURL: String?
    let category, area: String?
    let starRating: Double?
    let reviewCount, priceBracket: Int?
    let creator: Creator?

    enum CodingKeys: String, CodingKey {
        case id, title, likeCount, placeCount, isLiked, hasDeals, hasRequestedVenue, name
        case imageURL = "imageUrl"
        case category, area, starRating, reviewCount, priceBracket
        case creator
    }
}

struct RecommendationsRequest: Codable {
    let limit: Int
    let user: String?
    let pageToken: String?
    let venueId: String?
}

enum RecommendationsType: String {
    case playlist = "Playlist"
    case venue = "Venue"
}
