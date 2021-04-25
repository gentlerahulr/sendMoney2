import UIKit
extension UILabel {
    
    func getTextSize(_ font: UIFont, maxWidth: CGFloat) -> CGSize? {
        return self.text?.getTextSize(font, maxWidth: maxWidth)
    }
    
    func getText() -> String {
        guard let string = self.text else {
            return ""
        }
        return string
    }
    
    func setLineAndTextSpacingBy(lineSpacingValue: Double, textSpacingValue: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: textSpacingValue, range: NSRange(location: 0, length: attributedString.length - 1))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacingValue)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    func setLineSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(value)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func setLabelConfig(lblConfig: LabelConfig?) {
        guard let config = lblConfig else {
            debugPrint("Passed nil config")
            return
        }
        self.text = config.text
        
        if let numberOfLines = config.numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let textColor = config.textColor {
            self.textColor = textColor
        }
        if let textFont = config.font {
            self.font = textFont
        }
        if let lineSpacing = config.lineSpacing {
            self.setLineSpacingBy(value: lineSpacing)
        }
        if let textAlignment = config.textAlignment {
            self.textAlignment = textAlignment
        }
        if let textSpacing = config.textSpacing {
            if let text = self.text, !text.isEmpty {
                self.setTextSpacingBy(value: textSpacing)
            }
        }
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
}
