//
//  Enum.swift
//  SBC
//

//

import Foundation
import UIKit

struct NavButtonConfig {
    var font: UIFont?
    var textColor: UIColor?
    var backgroundColor: UIColor?
    var borderColor: UIColor?
    var cornerRadius: CGFloat?
    var image: UIImage?
    var imageTintColor: UIColor?
    var frame: CGRect?
    var title: String?
    var tag: Int?
    
    init(font: UIFont?, textColor: UIColor?, backgroundColor: UIColor?, borderColor: UIColor?, cornerRadius: CGFloat, image: UIImage?, imageTintColor: UIColor?, title: String?, frame: CGRect?, tag: Int = 0) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.image = image
        self.imageTintColor = imageTintColor
        self.title = title
        self.frame = frame
        self.tag = tag
    }
}
