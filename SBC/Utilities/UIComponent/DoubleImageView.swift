//
//  DoubleImageView.swift
//  SBC
//
//

import UIKit

@IBDesignable
class DoubleImageView: UIView {
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            redraw()
        }
    }
    
    @IBInspectable
    var compactCell: Bool = false {
        didSet {
            redraw()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func removeSubviews() {
        subviews.forEach {view in
            view.removeFromSuperview()
        }
    }
    
    private func redraw() {
        backgroundColor = .lightGray
        removeSubviews()
        addImages()
    }
    
    private func addImages() {
        guard let image = image else {
            return
        }
        addBackgroundView(image: image)
        addImageWithBorder(image: image)
        clipsToBounds = true
    }
    
    //frame calculation and not using auto layout as this seems to be in conflict with rotation and clipping.
    private func addImageWithBorder(image: UIImage) {
        let config = createDoubleImageViewConfig()
        let borderImageView = UIImageView(image: image)
        borderImageView.frame = CGRect(x: config.x, y: config.y, width: config.width, height: config.height)
        borderImageView.contentMode = .scaleAspectFill
        addSubview(borderImageView)
        borderImageView.layer.cornerRadius = config.cornerRadius
        borderImageView.clipsToBounds = true
        borderImageView.layer.borderWidth = config.borderWidth
        borderImageView.layer.borderColor = UIColor.white.cgColor
        borderImageView.rotate(degrees: config.rotationAngle)
    }
    
    private func addBackgroundView(image: UIImage) {
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.frame = bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.blurImage(alpha: 0.9)
        addSubview(backgroundImageView)
    }
    
    private func createDoubleImageViewConfig() -> DoubleImageViewConfig {
        if compactCell {
            let width =  bounds.width / 1.3
            let height = bounds.height * 1.3
            return DoubleImageViewConfig(width: width,
                                         height: height,
                                         x: -60,
                                         y: -55,
                                         cornerRadius: 40,
                                         borderWidth: 12,
                                         rotationAngle: -15)
        } else {
            let width = bounds.width - bounds.width / 5.2
            let height = bounds.height * 1.8
            return DoubleImageViewConfig(width: width,
                                         height: height,
                                         x: width / 4 * -1,
                                         y: height / 4.5 * -1,
                                         cornerRadius: height / 4,
                                         borderWidth: 12,
                                         rotationAngle: 15)
        }
    }

    struct DoubleImageViewConfig {
        let width: CGFloat
        let height: CGFloat
        let x: CGFloat
        let y: CGFloat
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
        let rotationAngle: CGFloat
    }
}
