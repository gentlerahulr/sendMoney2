import Foundation

enum PlaylistField {
    case description
    case title
    case subtitle
    case venueCaption
    case newList
    
    var screenTitle: String {
        switch self {
        case .description:
            return localizedStringForKey(key: "edit_description_screentitle")
        case .subtitle:
            return localizedStringForKey(key: "edit_subtitle_screentitle")
        case .title:
            return localizedStringForKey(key: "edit_title_screentitle")
        case .venueCaption:
            return localizedStringForKey(key: "edit_venueCaption_screentitle")
        case .newList:
            return localizedStringForKey(key: "edit_newList_screentitle")
        }
    }
    
    var title: String {
        switch self {
        case .description:
            return localizedStringForKey(key: "edit_description_title")
        case .subtitle:
            return localizedStringForKey(key: "edit_subtitle_title")
        case .title, .newList:
            return localizedStringForKey(key: "edit_title_title")
        case .venueCaption:
            return localizedStringForKey(key: "edit_venueCaption_title")
        }
    }
    var subtitle: String {
        switch self {
        case .description:
            return localizedStringForKey(key: "edit_description_subtitle")
        case .subtitle:
            return localizedStringForKey(key: "edit_subtitle_subtitle")
        case .title, .newList:
            return localizedStringForKey(key: "edit_title_subtitle")
        case .venueCaption:
            return localizedStringForKey(key: "edit_venueCaption_subtitle")
        }
    }
    
    var characterLimit: Int {
        switch self {
        case .description:
            return 200
        case .subtitle:
            return 45
        case .title, .newList:
            return 50
        case .venueCaption:
            return 250
            
        }
    }
    
    var minLengthError: String {
        switch self {
        case .description:
            return localizedStringForKey(key: "edit_description_minLength_error")
        case .subtitle:
            return localizedStringForKey(key: "edit_subtitle_minLength_error")
        case .title, .newList:
            return localizedStringForKey(key: "edit_title_minLength_error")
        case .venueCaption:
            return localizedStringForKey(key: "edit_venueCaption_minLength_error")
        }
    }
    
    var oneLetterError: String {
        switch self {
        case .description:
            return localizedStringForKey(key: "edit_description_oneLetter_error")
        case .subtitle:
            return localizedStringForKey(key: "edit_subtitle_oneLetter_error")
        case .title, .newList:
            return localizedStringForKey(key: "edit_title_oneLetter_error")
        case .venueCaption:
            return localizedStringForKey(key: "edit_venueCaption_oneLetter_error")
        }
    }
}
