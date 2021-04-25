//
//  UIFontExtension.swift
//  SBC
import UIKit
import Foundation

extension UIFont {
    
    class func regularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Regular", size: size)!
    }
    
    class func regularItalicFontWithSize(size: CGFloat) -> UIFont {
           return UIFont(name: "DMSans-Italic", size: size)!
       }
    
    class func mediumFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Medium", size: size)!
    }
    
    class func mediumWithItalicFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-MediumItalic", size: size)!
    }
    
    class func boldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Bold", size: size)!
    }
    
    class func boldWithItalicFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-BoldItalic", size: size)!
    }
    
}
