//
//  UIViewExtension.swift
//  SBC
//

import UIKit
import Foundation

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func setBorderWithColor(borderColor: UIColor?, borderWidth: CGFloat = 1.0, cornerRadius: CGFloat = 3.0) {
        
        guard let color = borderColor else {
            return
        }
        let borderWidth: CGFloat = borderWidth
        let cornerRadius: CGFloat = cornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func setCorner(_ radius: CGFloat) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setRoundedCorners(radius: CGFloat, corners: UIRectCorner) {
        
        var maskPath = UIBezierPath()
        maskPath    = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer                      = CAShapeLayer()
        maskLayer.path                     = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func applyGradient(colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyVerticalGradient(colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyDiagonalGradient(colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.type = .radial
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 1, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyConditionalGradient(colours: [UIColor], fromPoint: CGPoint, toPoint: CGPoint) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = fromPoint
        gradient.endPoint = toPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addDashedBorder(cornerRadius: CGFloat = 5) {
    
           let color = UIColor.white.cgColor
           self.layoutIfNeeded()
           let shapeLayer: CAShapeLayer = CAShapeLayer()
           let frameSize = self.frame.size
           let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
           shapeLayer.bounds = shapeRect
           shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
           shapeLayer.fillColor = UIColor.clear.cgColor
           shapeLayer.strokeColor = color
           shapeLayer.lineWidth = 6
           shapeLayer.lineJoin = CAShapeLayerLineJoin.round
           shapeLayer.lineDashPattern = [5, 7]
           shapeLayer.name = "DashBorder"
           shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
           self.layer.addSublayer(shapeLayer)
           }
}

extension UIView {
    func setIsHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            if self.isHidden && !hidden {
                self.alpha = 0.0
                self.isHidden = false
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            }) { (_) in
                self.isHidden = hidden
            }
        } else {
            self.isHidden = hidden
        }
    }
}

extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension UIView {
    public func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIView {
    
    func blurImage(alpha: CGFloat = 0.4) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    private var skeletonLayerName: String {
        return "skeletonLayerName"
    }

    private var skeletonGradientName: String {
        return "skeletonGradientName"
    }

    // 4
    private func skeletonViews(in view: UIView) -> [UIView] {
        var results = [UIView]()
        for subview in view.subviews as [UIView] {
            switch subview {
            case _ where subview.isKind(of: UILabel.self):
                results += [subview]
            case _ where subview.isKind(of: UIImageView.self):
                results += [subview]
            case _ where subview.isKind(of: UIButton.self):
                results += [subview]
            default:
                results += skeletonViews(in: subview)
            }

        }
        return results
    }

    // 5
    func showSkeleton() {
        let skeletons = skeletonViews(in: self)
        let backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        let highlightColor = UIColor.white.withAlphaComponent(0.2).cgColor

        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = UIScreen.main.bounds.size

        skeletons.forEach {
            let backgroundColor = $0.backgroundColor!.cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = UIScreen.main.bounds
            gradientLayer.name = skeletonGradientName

            $0.layer.mask = skeletonLayer
            $0.layer.addSublayer(skeletonLayer)
            $0.layer.addSublayer(gradientLayer)
            $0.clipsToBounds = true
            let width = UIScreen.main.bounds.width

            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -width
            animation.toValue = width
            animation.repeatCount = .infinity
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards

            gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
        }
    }

    // 6
    func hideSkeleton() {
        skeletonViews(in: self).forEach {
            $0.layer.sublayers?.removeAll {
                $0.name == skeletonLayerName || $0.name == skeletonGradientName
            }
        }
    }
}

extension UIView {
    ///rotates the whole view by a givin value (degrees)
    func rotate(degrees: CGFloat) {
        let radians = degrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}

extension UITableView {
    public func refresh() {
        self.beginUpdates()
        UIView.setAnimationsEnabled(false)
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func drawCustomRect(fillColor: UIColor) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height - 40))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
}

// MARK: loading of nib files
extension UIView {
    class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".components(separatedBy: ".").last!
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }  
}
