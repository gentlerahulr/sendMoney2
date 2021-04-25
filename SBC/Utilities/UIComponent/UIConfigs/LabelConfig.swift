import UIKit

struct LabelConfig {
    var text: String?
    var font: UIFont?
    var textColor: UIColor?
    var lineSpacing: Double?
    var textSpacing: Double?
    var textAlignment: NSTextAlignment?
    var numberOfLines: Int?
    
    static func getBoldLabelConfig(text: String?, fontSize: CGFloat = 22, textColor: UIColor? = .themeDarkBlue, lineSpacing: Double? = nil, textSpacing: Double? = nil, textAlignment: NSTextAlignment = .left, numberOfLines: Int? = 0) -> LabelConfig {
        return LabelConfig(text: text, font: .boldFontWithSize(size: fontSize), textColor: textColor, lineSpacing: lineSpacing, textSpacing: textSpacing, textAlignment: textAlignment, numberOfLines: numberOfLines)
    }
    
    static func getRegularLabelConfig(text: String?, fontSize: CGFloat = 16, textColor: UIColor? = .themeDarkBlue, lineSpacing: Double? = nil, textSpacing: Double? = nil, textAlignment: NSTextAlignment = .left, numberOfLines: Int? = 0) -> LabelConfig {
        return LabelConfig(text: text, font: .regularFontWithSize(size: fontSize), textColor: textColor, lineSpacing: lineSpacing, textSpacing: textSpacing, textAlignment: textAlignment, numberOfLines: numberOfLines)
    }
    
    static func getMediumLabelConfig(text: String?, fontSize: CGFloat = 16, textColor: UIColor? = .themeDarkBlue, lineSpacing: Double? = nil, textSpacing: Double? = nil, textAlignment: NSTextAlignment = .left, numberOfLines: Int? = 0) -> LabelConfig {
        return LabelConfig(text: text, font: .mediumFontWithSize(size: fontSize), textColor: textColor, lineSpacing: lineSpacing, textSpacing: textSpacing, textAlignment: textAlignment, numberOfLines: numberOfLines)
    }
}
