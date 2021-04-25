import UIKit

struct ButtonConfig {
    var titleText: String?
    var font: UIFont?
    var textColor: UIColor?
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat?
    var borderColor: UIColor?
    var borderWidth: CGFloat?
    
    static func getBoldButtonConfig(titleText: String?, fontSize: CGFloat = 22, textColor: UIColor = .themeDarkBlue,
                                    backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil,
                                    borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> ButtonConfig {
        return ButtonConfig(titleText: titleText, font: .boldFontWithSize(size: fontSize), textColor: textColor,
                            backgroundColor: backgroundColor, cornerRadius: cornerRadius, borderColor: borderColor,
                            borderWidth: borderWidth)
    }
    
    static func getRegularButtonConfig(titleText: String?, fontSize: CGFloat = 16, textColor: UIColor = .themeDarkBlue,
                                       backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil,
                                       borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> ButtonConfig {
        return ButtonConfig(titleText: titleText, font: .regularFontWithSize(size: fontSize), textColor: textColor,
                            backgroundColor: backgroundColor, cornerRadius: cornerRadius, borderColor: borderColor,
                            borderWidth: borderWidth)
    }
    
    static func getBackgroundButtonConfig(titleText: String?, fontSize: CGFloat = 16, textColor: UIColor = .white,
                                          backgroundColor: UIColor? = .themeDarkBlue, cornerRadius: CGFloat? = 20,
                                          borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> ButtonConfig {
        return ButtonConfig(titleText: titleText, font: .boldFontWithSize(size: fontSize), textColor: textColor,
                            backgroundColor: backgroundColor, cornerRadius: cornerRadius, borderColor: borderColor,
                            borderWidth: borderWidth)
        
    }
}
