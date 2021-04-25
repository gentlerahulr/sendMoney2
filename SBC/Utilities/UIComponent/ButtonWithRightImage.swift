import UIKit

@IBDesignable
class ButtonWithRightImage: UIButton {
    @IBInspectable var imageLeft: CGFloat = 15 {
        didSet {
            layoutSubviews()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - imageLeft), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageLeft, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
