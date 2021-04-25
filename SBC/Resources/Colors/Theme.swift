import Foundation
struct Themes: Codable {
    let primary_text_color: String?
    let secondary_text_color: String?
    let ternary_button_color: String?
    let primary_highlight_color: String?
    let primary_button_color: String?
    let disabled_color: String?
    let primary_button_negative_color: String?
    let navigation_header_color: String?
    let dark_navigation_header_color: String?
    let navigation_bar_color: String?
    let primary_background_color: String?
    let dashboard_quick_actions_background_color: String?
    let dashboard_quick_actions_logo_color: String?
    let dashboard_quick_actions_sub_text_color: String?
    let quick_actions_options_button_color: String?
    let quick_actions_options_overlay_logo_color: String?
    let list_selection_color: String?
    let edit_field_secondary_text_color: String?
    
    enum CodingKeys: String, CodingKey {
        case primary_text_color
        case primary_highlight_color
        case secondary_text_color
        case ternary_button_color
        case primary_button_color
        case primary_button_negative_color
        case disabled_color
        case navigation_header_color
        case dark_navigation_header_color
        case navigation_bar_color
        case primary_background_color
        case dashboard_quick_actions_background_color
        case dashboard_quick_actions_logo_color
        case dashboard_quick_actions_sub_text_color
        case quick_actions_options_button_color
        case quick_actions_options_overlay_logo_color
        case list_selection_color
        case edit_field_secondary_text_color
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        primary_text_color = try values.decodeIfPresent(String.self, forKey: .primary_text_color)
        primary_highlight_color = try values.decodeIfPresent(String.self, forKey: .primary_highlight_color)
        secondary_text_color = try values.decodeIfPresent(String.self, forKey: .secondary_text_color)
        ternary_button_color = try values.decodeIfPresent(String.self, forKey: .ternary_button_color)
        primary_button_color = try values.decodeIfPresent(String.self, forKey: .primary_button_color)
        primary_button_negative_color = try values.decodeIfPresent(String.self, forKey: .primary_button_negative_color)
        disabled_color = try values.decodeIfPresent(String.self, forKey: .disabled_color)
        navigation_header_color = try values.decodeIfPresent(String.self, forKey: .navigation_header_color)
        dark_navigation_header_color = try values.decodeIfPresent(String.self, forKey: .dark_navigation_header_color)
        navigation_bar_color = try values.decodeIfPresent(String.self, forKey: .navigation_bar_color)
        primary_background_color = try values.decodeIfPresent(String.self, forKey: .primary_background_color)
        dashboard_quick_actions_background_color = try values.decodeIfPresent(String.self, forKey: .dashboard_quick_actions_background_color)
        dashboard_quick_actions_logo_color = try values.decodeIfPresent(String.self, forKey: .dashboard_quick_actions_logo_color)
        dashboard_quick_actions_sub_text_color = try values.decodeIfPresent(String.self, forKey: .dashboard_quick_actions_sub_text_color)
        quick_actions_options_button_color = try values.decodeIfPresent(String.self, forKey: .quick_actions_options_button_color)
        quick_actions_options_overlay_logo_color = try values.decodeIfPresent(String.self, forKey: .quick_actions_options_overlay_logo_color)
        list_selection_color = try values.decodeIfPresent(String.self, forKey: .list_selection_color)
        edit_field_secondary_text_color = try values.decodeIfPresent(String.self, forKey: .edit_field_secondary_text_color)
    }
    
}
