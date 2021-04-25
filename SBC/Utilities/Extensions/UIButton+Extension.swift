//
//  UIButton+Extension.swift
//  SBC

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func setImage(image: UIImage?, tintColor: UIColor?, forUIControlState state: UIControl.State) {
        
        self.setImage(image, for: state)
        if let color = tintColor {
            self.tintColor = color
        }
    }
    
    func setButtonConfig(btnConfig: ButtonConfig?, for state: UIButton.State = .normal) {
        guard let config = btnConfig else {
            debugPrint("passed nil config object")
            return
        }
        if let titleText = config.titleText {
            setTitle(titleText, for: .normal)
        }
        if let titleColor = config.textColor {
            self.setTitleColor(titleColor, for: state)
        }
        if let titleFont = config.font {
            self.titleLabel?.font = titleFont
        }
        setBackgroundImage(
            buttonBackgroundImage(
                color: config.backgroundColor ?? .clear,
                borderColor: config.borderColor ?? .clear,
                cornerRadius: config.cornerRadius ?? 0,
                borderWidth: config.borderWidth ?? 0
            ),
            for: state
        )
    }
    
    func underlineButton(text: String, fontSize: CGFloat = 13) {
        setAttributedTitle(
            NSAttributedString(
                string: text,
                attributes: [
                    .font: UIFont.mediumFontWithSize(size: fontSize),
                    .foregroundColor: UIColor.themeDarkBlue,
                    .underlineStyle: NSUnderlineStyle.thick.rawValue as NSNumber,
                    .underlineColor: UIColor.themeNeonBlue
                ]
            ),
            for: .normal
        )
    }
}

private func buttonBackgroundImage(
    color: UIColor,
    borderColor: UIColor,
    cornerRadius: CGFloat,
    borderWidth: CGFloat
) -> UIImage? {
    let capInsetWidth = (borderWidth / 2) + cornerRadius
    let dimension: CGFloat = capInsetWidth * 2 + 1
    let imageSize = CGSize(width: dimension, height: dimension)
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
    defer {
        UIGraphicsEndImageContext()
    }
    let pathRect = CGRect(origin: .zero, size: imageSize).insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
    let path = UIBezierPath(roundedRect: pathRect, cornerRadius: cornerRadius)
    color.setFill()
    borderColor.setStroke()
    path.fill()
    path.stroke()

    return UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(
        withCapInsets: UIEdgeInsets(
            top: capInsetWidth,
            left: capInsetWidth,
            bottom: capInsetWidth,
            right: capInsetWidth
        )
    )
}
