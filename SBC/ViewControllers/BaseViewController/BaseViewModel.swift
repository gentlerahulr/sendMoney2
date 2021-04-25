//
//  BaseViewControllerViewModel.swift
//  SBC
//

import Foundation
import UIKit

class BaseViewModel {
    var colors: MyColors = MyColors()
    var fonts: Fonts   = Fonts()
    
    //------------------------------------------------------------------
    
    private struct Images {
        let Leftbutton = "img_back"
    }
    
    //------------------------------------------------------------------
    
    public class MyColors {
        var Leftbutton = colorConfig.navigation_header_icon_color
        var TitleColor = colorConfig.navigation_header_text_color
    }
    
    //------------------------------------------------------------------
    
    public class Fonts {
        let Leftbutton  = CGFloat(21)
    }
    
    //------------------------------------------------------------------
    
    public func letfButtonImgae() -> String? {
        return Images().Leftbutton
    }
    
    //------------------------------------------------------------------
    
    public func leftButtonImageColor () -> String? {
        return colors.Leftbutton
    }
    
    //------------------------------------------------------------------
    
    public func leftButtonTitleColor () -> String? {
        return colors.Leftbutton
    }
    
    //------------------------------------------------------------------
    
    public func titleFont () -> UIFont? {
        return UIFont.regularFontWithSize(size: 14)
    }
    
    //------------------------------------------------------------------
    
    public func LeftTitleFont () -> UIFont? {
        return UIFont.regularFontWithSize(size: 14)
    }
    
    //------------------------------------------------------------------
    
    public func RightTitleFont () -> UIFont? {
        return UIFont.regularFontWithSize(size: 14)
    }
    
    //------------------------------------------------------------------
    
    public func navigationTitleColor () -> String? {
        return colors.TitleColor
    }
    
    //------------------------------------------------------------------
    
    public func disableComponentOpacity () -> Float? {
        return 0.5
    }
}
