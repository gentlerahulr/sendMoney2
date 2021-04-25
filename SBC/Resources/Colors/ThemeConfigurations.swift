//
//  ThemeConfigurations.swift
//  SBC
//

//

import Foundation
import UIKit

/// This function is for  set the Color theme of the app
func setColorConfig(to: ColorTheme? = nil) {
    if let theme = to, (type(of: theme) == type(of: ONZTheme())) {
        colorConfig = GlobalTheme().theme
        AppConfigurations().config = nil
        return
    }
    JsonHelper.getJsonData(fileName: "config.json") { (result: Result<ColorResponceDTO, Error>)  in
        switch result {
        case .success(let model):
            let newConfig = model.themes
            if let newCofi = newConfig {
                let config = ClientTheme(theme: newCofi)
                colorConfig = GlobalTheme(theme: config).theme
            }
            
        case .failure:
            colorConfig = GlobalTheme().theme
        }
    }
}

var colorConfig: ColorTheme = {
    return GlobalTheme().theme
}()

protocol ColorTheme {
    //Text
    var primary_text_color: String? { get }
    var primary_placeholder_color: String? { get }
    var secondary_text_color: String? { get }
    var primary_text_disabled_color: String? { get }
    
    //Button
    var primary_button_color: String? { get }
    var primary_button_text_color: String? { get }
    var primary_button_border_color: String? { get }
    var primary_button_underline_color: String? { get }
    var primary_button_disabled_color: String? { get }
    var primary_button_negative_color: String? { get }
    var ternary_button_color: String? { get }
    
    //Navigation
    var navigation_header_text_color: String? { get }
    var dark_navigation_header_text_color: String? { get }
    var navigation_header_icon_color: String? { get }
    var navigation_header_color: String? { get }
    
    var primary_background_color: String?? { get }
    
    //Dashboard
    var dashboard_quick_actions_background_color: String? { get }
    var dashboard_quick_actions_logo_color: String? { get }
    var dashboard_quick_actions_sub_text_color: String? { get }
    
    //QuickActions
    var quick_actions_options_overlay_background_color: String? { get }
    var quick_actions_options_overlay_logo_color: String? { get }
    var quick_actions_options_overlay_text_color: String? { get }
    
    //Checkbox
    var checkbox_color: String? { get }
    
    //List Selection color
    var list_selection_color: String? { get }
    
    //Edit field
    var edit_field_secondary_text_color: String? { get }
}

struct ONZTheme: ColorTheme {
    var primary_text_color: String? = "#172553"
    var primary_placeholder_color: String? = "#ffffff"
    var secondary_text_color: String? = "#32c5ff"
    var primary_text_disabled_color: String? = "#707070"
    
    var primary_button_color: String? = "#172553"
    var primary_button_text_color: String? = "#172553"
    var primary_button_border_color: String? = "#172553"
    var primary_button_underline_color: String? = "#00f5e4"
    var primary_button_disabled_color: String? = "#C5C8D4"
    var primary_button_negative_color: String? = "#ff001f"
    
    var ternary_button_color: String?
    
    var navigation_header_text_color: String? = "#000000"
    var navigation_header_icon_color: String? = "#000000"
    var dark_navigation_header_text_color: String? = "#FFFFFF"
    
    var navigation_header_color: String? =  "#FFFFFF"
    
    var primary_background_color: String?? = "#172553"
    
    var dashboard_quick_actions_background_color: String? = "#808b94"
    var dashboard_quick_actions_logo_color: String? =  "#ffffff"
    var dashboard_quick_actions_sub_text_color: String? = "#a8a9ae"
    
    var quick_actions_options_overlay_background_color: String? = "#f6b918"
    var quick_actions_options_overlay_logo_color: String? = "#ffffff"
    var quick_actions_options_overlay_text_color: String? = "#ffffff"
    
    var checkbox_color: String? = "#00F5E4"
    var list_selection_color: String? = "#21233c"
    
    var edit_field_secondary_text_color: String? = "#676f89"
}

struct ClientTheme: ColorTheme {
    var primary_text_color: String?
    var primary_placeholder_color: String?
    var secondary_text_color: String?
    var primary_text_disabled_color: String?
    
    var primary_button_color: String?
    var primary_button_text_color: String?
    var primary_button_border_color: String?
    var primary_button_underline_color: String?
    var primary_button_disabled_color: String?
    var primary_button_negative_color: String?
    
    var ternary_button_color: String?
    
    var navigation_header_text_color: String?
    var navigation_header_icon_color: String?
    var dark_navigation_header_text_color: String?
    
    var navigation_header_color: String?
    var primary_background_color: String??
    
    var dashboard_quick_actions_background_color: String?
    var dashboard_quick_actions_logo_color: String?
    var dashboard_quick_actions_sub_text_color: String?
    
    var quick_actions_options_overlay_background_color: String?
    var quick_actions_options_overlay_text_color: String?
    var quick_actions_options_overlay_logo_color: String?
    
    var checkbox_color: String?
    var list_selection_color: String?
    
    var edit_field_secondary_text_color: String?
    
    init(theme: Themes) {
        primary_text_color = theme.primary_text_color ?? ONZTheme().primary_text_color
        
        primary_placeholder_color = theme.primary_highlight_color ?? ONZTheme().primary_placeholder_color
        secondary_text_color = theme.secondary_text_color ?? ONZTheme().secondary_text_color
        
        primary_text_disabled_color = theme.disabled_color ?? ONZTheme().primary_text_disabled_color

        primary_button_color = theme.primary_button_color ?? ONZTheme().primary_button_color
        primary_button_text_color = theme.primary_highlight_color ?? ONZTheme().primary_button_text_color
        primary_button_border_color = theme.primary_button_color ?? ONZTheme().primary_button_border_color
        primary_button_underline_color = theme.primary_button_color ?? ONZTheme().primary_button_underline_color
        primary_button_disabled_color = theme.disabled_color ?? ONZTheme().primary_button_disabled_color
        primary_button_negative_color = theme.primary_button_negative_color ?? ONZTheme().primary_button_negative_color
        ternary_button_color = theme.ternary_button_color ?? ONZTheme().ternary_button_color

        navigation_header_text_color = theme.navigation_header_color ?? ONZTheme().navigation_header_text_color
        navigation_header_icon_color = theme.navigation_header_color ?? ONZTheme().navigation_header_icon_color
        dark_navigation_header_text_color = theme.dark_navigation_header_color ?? ONZTheme().dark_navigation_header_text_color

        navigation_header_color = theme.navigation_bar_color ?? ONZTheme().navigation_header_color
        primary_background_color = theme.primary_background_color

        dashboard_quick_actions_background_color = theme.dashboard_quick_actions_background_color ?? ONZTheme().dashboard_quick_actions_background_color
        dashboard_quick_actions_logo_color = theme.dashboard_quick_actions_logo_color ?? ONZTheme().dashboard_quick_actions_logo_color
        dashboard_quick_actions_sub_text_color = theme.dashboard_quick_actions_background_color ?? ONZTheme().dashboard_quick_actions_sub_text_color
        if let text_color = theme.dashboard_quick_actions_sub_text_color {
            dashboard_quick_actions_sub_text_color = text_color
        }

        quick_actions_options_overlay_background_color = theme.quick_actions_options_button_color ?? ONZTheme().quick_actions_options_overlay_background_color
        
        quick_actions_options_overlay_text_color = theme.quick_actions_options_overlay_logo_color ?? ONZTheme().quick_actions_options_overlay_text_color
        
        quick_actions_options_overlay_logo_color = theme.quick_actions_options_overlay_logo_color ?? ONZTheme().quick_actions_options_overlay_logo_color

        checkbox_color = theme.secondary_text_color ?? ONZTheme().checkbox_color
        list_selection_color = theme.list_selection_color ?? ONZTheme().list_selection_color
        edit_field_secondary_text_color = theme.edit_field_secondary_text_color ?? ONZTheme().edit_field_secondary_text_color
    }
}

class GlobalTheme {
    var theme: ColorTheme
    
    init(theme: ColorTheme? = nil) {
        if theme == nil {
            self.theme = ONZTheme()
        } else {
            self.theme = theme!
        }
    }
}
