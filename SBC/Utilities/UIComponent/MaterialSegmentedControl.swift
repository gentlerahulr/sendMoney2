import UIKit

open class MaterialSegmentedControl: UIControl {
    
    public var selectedSegmentIndex = 0
    
    var stackView: UIStackView!
    open var selector: UIView!
    open var bottomBar: UIView!
    open var segments = [UIButton]() {
        didSet {
            updateViews()
        }
    }
    
    public var selectorColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    public var selectedForegroundColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    public var foregroundColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /**
     Convenience initializer of MaterialSegmentedControl.
     
     - Parameter segments:        The segment in UIButton form.
     - Parameter selectedFgColor: The foreground color of the selected segment.
     - Parameter selectorColor:   The color of the selector.
     - Parameter bgColor:         Background color.
     */
    public convenience init(segments: [UIButton] = [], selectedFgColor: UIColor, selectorColor: UIColor, bgColor: UIColor) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectedForegroundColor = selectedFgColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
    }
    
    open func setupUI() {
        self.selectedForegroundColor = .themeDarkBlue
        self.foregroundColor = .themeDarkBlueTint1
        self.selectorColor = .themeNeonBlue
        self.backgroundColor = .white
    }
    
    open func setSegments(segmentText: [String]) {
        for segment in segmentText {
            appendSegment(text: segment)
        }
    }
    
    open func appendSegment(text: String? = nil) {
        let button = UIButton()
        button.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: text))
        button.backgroundColor = .clear
        self.segments.append(button)
    }
    
    func updateViews() {
        guard segments.count > 0 else { return }
        for idx in 0..<segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
        
        // Create a StackView
        stackView = UIStackView(arrangedSubviews: segments)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        selector = UIView(frame: .zero)
        selector.backgroundColor = selectorColor
        
        bottomBar = UIView(frame: .zero)
        bottomBar.backgroundColor = .themeDarkBlueTint3
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        [bottomBar, selector, stackView].forEach { (view) in
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let firstBtn = segments.first {
            buttonTapped(button: firstBtn)
        }
        
        self.layoutSubviews()
    }
    // AutoLayout
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        selector.heightAnchor.constraint(equalToConstant: 4.0).isActive = true
        
        bottomBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1.0).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        if let selector = selector, let first = stackView.arrangedSubviews.first {
            self.addConstraint(NSLayoutConstraint(item: selector, attribute: .width, relatedBy: .equal, toItem: first, attribute: .width, multiplier: 1.0, constant: 0.0))
        }
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.layoutIfNeeded()
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            btn.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: btn.currentTitle, fontSize: 13, textColor: foregroundColor))
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: btn.currentTitle, fontSize: 13, textColor: selectedForegroundColor))
               
                moveView(selector, toX: btn.frame.origin.x)
            }
        }
        sendActions(for: .valueChanged)
    }
    /**
     Moves the view to the right position.
     
     - Parameter view:       The view to be moved to new position.
     - Parameter duration:   The duration of the animation.
     - Parameter completion: The completion handler.
     - Parameter toView:     The targetd view frame.
     */
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: toX, y: 0.0)
        }, completion: completion)
    }
}
