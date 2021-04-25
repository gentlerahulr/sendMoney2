//
//  ColorExtension.swift
//  SBC
//

import Foundation
import UIKit

extension UIColor {
    /// Computed property returning tuple with red, green, blue and alpha value
    //swiftlint:disable large_tuple
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    // MARK: - UIColor from RGB
    /**
     this method will give you UIColor of color code.
     
     - parameter colorCode: color code as exp: ffffff
     - parameter alpha: alpha value for color
     
     - returns: UIColor of color code
     */
    
    static func getUIColorFromHexCode(colorCode: String, alpha: Float ) -> UIColor {
        let HEX_MASK = 0x000000FF
        let SHIFT_RED: UInt32 =  16
        let SHIFT_GREEN: UInt32 = 8
        let RBG_MASK: Float = 255.0
        let scanner = Scanner(string: colorCode)
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = HEX_MASK
        let redFromHex = CGFloat(Float(Int(color >> SHIFT_RED) & mask)/RBG_MASK)
        let greenFromHex = CGFloat(Float(Int(color >> SHIFT_GREEN) & mask)/RBG_MASK)
        let blueFromHex = CGFloat(Float(Int(color) & mask)/RBG_MASK)
        return UIColor(red: redFromHex, green: greenFromHex, blue: blueFromHex, alpha: CGFloat(alpha))
    }
    
    //Get Color from hex code
    public convenience init?(_ hexStringValue: String) {

        let r, g, b, a: CGFloat
        if hexStringValue.hasPrefix("#") {
            let start = hexStringValue.index(hexStringValue.startIndex, offsetBy: 1)
            let hexColor = String(hexStringValue[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                   
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                    a = 1.0
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
    
    class var themeLightBlue: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeLightBlue, alpha: 1.0)
    }
    
    class var themeDarkBlue: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
    }
    
    class var themeRed: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeRed, alpha: 1.0)
    }
    
    class var themeNeonBlue: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeNeonBlue, alpha: 1.0)
    }
    
    class var themeNeonBlue2: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeNeonBlue2, alpha: 1.0)
    }

    class var themeNeonYellowTint2: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeNeonYellowTint2, alpha: 1.0)
    }
    
    class var themeNeonGreen: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeNeonGreen, alpha: 1.0)
    }
    
    class var themeDarkBlueTint1: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint1, alpha: 1.0)
    }
    
    class var themeDarkBlueTint2: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint2, alpha: 1.0)
    }

    class var themeDarkBlueTint3: UIColor {
        return .getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlueTint3, alpha: 1.0)
    }
    
    class var themeWhite: UIColor {
        return UIColor.white
    }
}
