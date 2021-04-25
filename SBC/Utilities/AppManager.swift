//
//  AppManager.swift
//  SBC

import UIKit
struct AppManager {    
    enum TextStyle {
        case title
        case boldTitle
        case subtitle
        case placeHolder
        case inputText
        case primaryActionButton
        case button
        case countryCodeButton
    }
    
    struct TextAttributes {
        let font: UIFont
        let color: UIColor
        let backgroundColor: UIColor?
        
        init(font: UIFont, color: UIColor, backgroundColor: UIColor? = nil) {
            self.font = font
            self.color = color
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - General Properties
    let backgroundColor: UIColor
    let attributesForStyle: (_ style: TextStyle) -> TextAttributes
    
    init(backgroundColor: UIColor,
         preferredStatusBarStyle: UIStatusBarStyle = .default,
         attributesForStyle: @escaping (_ style: TextStyle) -> TextAttributes) {
        self.backgroundColor = backgroundColor
        //        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.attributesForStyle = attributesForStyle
    }
    
    // MARK: - Convenience Getters
    func font(for style: TextStyle) -> UIFont {
        return attributesForStyle(style).font
    }
    
    func color(for style: TextStyle) -> UIColor {
        return attributesForStyle(style).color
    }
    
    func backgroundColor(for style: TextStyle) -> UIColor? {
        return attributesForStyle(style).backgroundColor
    }
    
    func apply(textStyle: TextStyle, to label: UILabel) {
        let attributes = attributesForStyle(textStyle)
        
        label.font = attributes.font
        label.textColor = attributes.color
        label.backgroundColor = attributes.backgroundColor
    }
    
    func apply(textStyle: TextStyle = .button, to button: UIButton) {
        let attributes = attributesForStyle(textStyle)
        button.setTitleColor(attributes.color, for: .normal)
        button.titleLabel?.font = attributes.font
        button.backgroundColor = attributes.backgroundColor
    }
    
}
extension AppManager {
    static var appStyle: AppManager {
        return AppManager(
            backgroundColor: .black,
            preferredStatusBarStyle: .lightContent,
            attributesForStyle: { $0.appAttributes }
        )
    }
}
private extension AppManager.TextStyle {
    
    var appAttributes: AppManager.TextAttributes {
        
        switch self {
        case .title:
            return AppManager.TextAttributes(font: UIFont.regularFontWithSize(size: 13), color: UIColor(colorConfig.primary_text_color!)!, backgroundColor: .white)
        case .boldTitle:
            return AppManager.TextAttributes(font: UIFont.mediumFontWithSize(size: 15), color: UIColor(colorConfig.primary_text_color!)!, backgroundColor: .white)
        case .subtitle:
            return AppManager.TextAttributes(font: UIFont.regularFontWithSize(size: 13), color: UIColor(colorConfig.primary_text_color!)!, backgroundColor: .white)
        case .placeHolder:
            return AppManager.TextAttributes(font: UIFont.mediumFontWithSize(size: 13), color: .themeLightBlue, backgroundColor: .white)
        case .button:
            return AppManager.TextAttributes(font: UIFont.mediumFontWithSize(size: 18), color: UIColor.white, backgroundColor: UIColor.clear)
        case .inputText:
            return AppManager.TextAttributes(font: UIFont.regularFontWithSize(size: 14), color: .themeDarkBlue, backgroundColor: UIColor.clear)
        case .primaryActionButton:
            return AppManager.TextAttributes(font: UIFont.mediumFontWithSize(size: 16), color: .themeDarkBlue, backgroundColor: UIColor.clear)
    case .countryCodeButton:
        return AppManager.TextAttributes(font: UIFont.regularFontWithSize(size: 15), color: .themeLightBlue, backgroundColor: .clear)
            
        }
    }
}
