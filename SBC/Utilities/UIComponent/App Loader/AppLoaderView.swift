//
//  AppLoader.swift
//  SBC

import UIKit

class AppLoaderView: UIView {
    func instanceFromNib() -> AppLoaderView {
        return UINib(nibName: "AppLoader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AppLoaderView
    }
}
