//
//  LSBannerView.swift

import Foundation

protocol LSAlert {
    func initiate()
    func showMessage(_ message: String, state: AlertState)
    func showMessageWithDismiss(_ message: String, state: AlertState)
    func showBottomMessageWithDismiss(_ message: String, details: String?, state: AlertState)
    
}

enum AlertState {
    case success
    case failure
}

class AlertViewAdapter {
    var bannerView: LSAlert
    static let shared = AlertViewAdapter(bannerView: LSBannerView()) // Set other Banners here
    
    init(bannerView: LSAlert) {
        self.bannerView = bannerView
        self.bannerView.initiate()
    }
    
    func show(_ message: String, state: AlertState) {
        if message.lowercased() != "unauthorized" {
            self.bannerView.showMessage(message, state: state)
        }
    }
    
    func showMessageWithDismiss(_ message: String, state: AlertState) {
        if message.lowercased() != "unauthorized" {
            self.bannerView.showMessageWithDismiss(message, state: state)
        }
    }
    
    func showBottomMessageWithDismiss(_ message: String, details: String?, state: AlertState) {
        if message.lowercased() != "unauthorized" {
            self.bannerView.showBottomMessageWithDismiss(message, details: details, state: state)
        }
    }
}
