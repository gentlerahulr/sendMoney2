//
//  LSBannerView.swift

import Foundation
import BRYXBanner

class LSBannerView: LSAlert {
    
    var bannerView: Banner?
    
    func initiate() {
        //For BRYX BannerView we have to create each instance // TODO use more lightweight sdk
    }
    
    func showMessage(_ message: String, state: AlertState) {
        let banner = Banner.init()
        banner.titleLabel.font  = UIFont.regularFontWithSize(size: CGFloat(16))
        banner.titleLabel.textAlignment = .center
        banner.dismissesOnTap = true
        
        switch state {
        case .success:
            banner.titleLabel.font  = UIFont.boldFontWithSize(size: CGFloat(16))
            banner.titleLabel.textColor = .themeDarkBlue
            banner.backgroundColor = UIColor.green
        case .failure:
            banner.backgroundColor = .themeRed
        }
        
        banner.titleLabel.text = message
        banner.show(duration: 1.5)
    }
    
    func showMessageWithDismiss(_ message: String, state: AlertState) {
        if bannerView != nil {
            bannerView?.dismiss()
            bannerView = nil
        }
        bannerView = Banner.init()
        bannerView?.titleLabel.font  = UIFont.regularFontWithSize(size: CGFloat(16))
        bannerView?.titleLabel.textAlignment = .center
        bannerView?.dismissesOnTap = true
        
        switch state {
        case .success:
            bannerView?.backgroundColor =  UIColor.green
        case .failure:
            bannerView?.backgroundColor =  .themeRed
        }
        
        bannerView?.titleLabel.text = message
        bannerView?.show(duration: 1.5)
    }
    
    func showBottomMessageWithDismiss(_ message: String, details: String?, state: AlertState) {
        if bannerView != nil {
            bannerView?.dismiss()
            bannerView = nil
        }
        bannerView = Banner.init()
        bannerView?.titleLabel.font  = UIFont.boldFontWithSize(size: CGFloat(16))
        bannerView?.titleLabel.textAlignment = .left
        bannerView?.titleLabel.textColor = UIColor.themeDarkBlue
        bannerView?.position = .bottom
        bannerView?.dismissesOnTap = true
        
        if details != nil {
            bannerView?.detailLabel.text = details
            bannerView?.detailLabel.font  = UIFont.regularFontWithSize(size: CGFloat(16))
            bannerView?.detailLabel.textAlignment = .left
            bannerView?.detailLabel.textColor = UIColor.themeDarkBlue
        }
        
        switch state {
        case .success:
            bannerView?.backgroundColor =  UIColor.themeNeonBlue
        case .failure:
            bannerView?.backgroundColor =  .themeRed
        }
        
        bannerView?.titleLabel.text = message
        bannerView?.show(duration: 1.5)
    }
}
