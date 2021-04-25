import Foundation

struct PlaylistsRequest: Codable {
    let limit: Int?
    let user: String?
    let pageToken: String?
    let venueId: String?
    var liked: String?
}

struct PlaylistDetailsRequest: Codable {
    let id: String
}

struct MyLikesRequest: Codable {
}

struct CreatePlaylistRequest: Codable {
    let title: String?
    let subtitle: String?
    let description: String?
    let venueId: String?
}

struct PlaylistEditRequest: Codable {
    let title: String?
    let subtitle: String?
    let description: String?
}

struct ToggleLikePlaylistRequest: Codable {
    let id: String
}
struct ToggleLikePlaylistResponse: Codable {
    let data: Bool
}

struct AddVenueToPlaylistRequest: Codable {
    let venueId: String
}

struct DeleteVenueFromPlaylistRequest: Codable {
}

struct DeletePlaylistRequest: Codable {
    let id: String
}

struct EmptyResponse: Decodable {
    
}

struct MyLikes: Decodable {
    var playlists: Playlists?
    var venues: Venues?
    private enum CodingKeys: String, CodingKey {
        case playlists
        case venues
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data) {
            playlists = try? nestedContainer.decode(Playlists.self, forKey: .playlists)
            venues = try? nestedContainer.decode(Venues.self, forKey: .venues)
            
        }
    }
}

struct Playlists: Decodable, Equatable {
    var data: [Playlist]?
    let limit: Int
    var count: Int
    var nextPageToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case nextPageToken
        case limit
        case count
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nextPageToken = try? container.decode(String.self, forKey: .nextPageToken)
        count = try container.decode(Int.self, forKey: .count)
        limit = try container.decode(Int.self, forKey: .limit)
        data = try? container.decode([Playlist].self, forKey: .data)
        
    }
}

struct Playlist: Decodable, Equatable {
    let id: String
    var title: String?
    var subtitle: String?
    var likeCount: Int
    var placeCount: Int
    var description: String?
    var imageUrl: String?
    var isLiked: Bool
    let hasDeals: Bool?
    let updated: Date?
    let creator: Creator?
    var venues: Venues?
    let hasRequestedVenue: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case likeCount
        case placeCount
        case description
        case imageUrl
        case isLiked
        case hasDeals
        case updated
        case creator
        case venues
        case data
        case hasRequestedVenue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data) {
            id = try nestedContainer.decode(String.self, forKey: .id)
            title = try? nestedContainer.decode(String.self, forKey: .title)
            subtitle = try? nestedContainer.decode(String.self, forKey: .subtitle)
            likeCount = try nestedContainer.decode(Int.self, forKey: .likeCount)
            placeCount = try nestedContainer.decode(Int.self, forKey: .placeCount)
            description = try? nestedContainer.decode(String.self, forKey: .description)
            imageUrl = try? nestedContainer.decode(String.self, forKey: .imageUrl)
            isLiked = try nestedContainer.decode(Bool.self, forKey: .isLiked)
            hasDeals = try? nestedContainer.decode(Bool.self, forKey: .hasDeals)
            if let date = try? nestedContainer.decode(String.self, forKey: .updated) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                updated = dateFormatter.date(from: date)
            } else {
                updated = nil
            }
            creator = try? nestedContainer.decode(Creator.self, forKey: .creator)
            venues = try? nestedContainer.decode(Venues.self, forKey: .venues)
            hasRequestedVenue = try? nestedContainer.decode(Bool.self, forKey: .hasRequestedVenue)
        } else {
            id = try container.decode(String.self, forKey: .id)
            title = try? container.decode(String.self, forKey: .title)
            subtitle = try? container.decode(String.self, forKey: .subtitle)
            likeCount = try container.decode(Int.self, forKey: .likeCount)
            placeCount = try container.decode(Int.self, forKey: .placeCount)
            description = try? container.decode(String.self, forKey: .description)
            imageUrl = try? container.decode(String.self, forKey: .imageUrl)
            isLiked = try container.decode(Bool.self, forKey: .isLiked)
            hasDeals = try? container.decode(Bool.self, forKey: .hasDeals)
            if let date = try? container.decode(String.self, forKey: .updated) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                updated = dateFormatter.date(from: date)
            } else {
                updated = nil
            }
            creator = try? container.decode(Creator.self, forKey: .creator)
            venues = try? container.decode(Venues.self, forKey: .venues)
            hasRequestedVenue = try? container.decode(Bool.self, forKey: .hasRequestedVenue)
        }
        
    }
}

struct Creator: Decodable, Equatable {
    let id: String
    let username: String?
    let profilePictureUrl: String?
}
