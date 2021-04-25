import Foundation

protocol DeleteFieldProtocol: NSObject {
    func delete(field: DeleteField, venue: Venue?)
}

enum DeleteField {
    case playlist
    case venue
    case playlistAndVenue
    
    var sheetTitle: String {
        switch self {
        case .playlist:
            return localizedStringForKey(key: "delete_list_title")
        case .venue:
            return localizedStringForKey(key: "delete_venue_title")
        case .playlistAndVenue:
            return localizedStringForKey(key: "delete_playlist_venue_title")
        }
    }
    
    var sheetSubtitle: String {
        switch self {
        case .playlist:
            return localizedStringForKey(key: "delete_list_subtitle")
        case .venue:
            return localizedStringForKey(key: "delete_venue_subtitle")
        case .playlistAndVenue:
            return localizedStringForKey(key: "delete_playlist_venue_subtitle")
        }
    }
    
    var deleteButtonTitle: String {
        switch self {
        case .playlist:
            return localizedStringForKey(key: "delete_list_button_title")
        case .venue:
            return localizedStringForKey(key: "delete_venue_button_title")
        case .playlistAndVenue:
            return localizedStringForKey(key: "delete_playlist_venue_button_title")
        }
    }
}
