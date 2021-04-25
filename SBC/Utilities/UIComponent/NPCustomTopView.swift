//
//  Enum.swift
//  SBC
//

//

import UIKit

private var topBackButtonFrame = CGRect(x: 10, y: UIDevice.current.hasNotch ? 44 : 24, width: 50, height: 50)
private var topTitleLabelFrame = CGRect(x: 87, y: UIDevice.current.hasNotch ? 44 : 24, width: UIScreen.main.bounds.width - 174, height: 50)
private var topLeftButtonFrame = CGRect(x: UIScreen.main.bounds.width - 60, y: UIDevice.current.hasNotch ? 44 : 24, width: 50, height: 50)

public protocol CustomTopViewDelegate: class {
    func rightButtonAction(button: UIButton)
    func leftButtonAction(button: UIButton)
}

class NPCustomTopView: UIView {
    
    public weak var delegate: CustomTopViewDelegate?
    private var leftButton: UIButton?
    private var rightButton: UIButton?
    private var headerTitle: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //------------------------------------------------------------------
    //initWithCode to init view from xib or storyboard
    //------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //------------------------------------------------------------------
    //common func to init our view
    //------------------------------------------------------------------
    
    private func setupView() {
    }
    
    //------------------------------------------------------------------
    
    public func setTitle(title: String) {
        headerTitle?.text = title
    }
    
    //------------------------------------------------------------------
    
    public func showHeaderWithTitle(title: String?, titleFont: UIFont?, titleTextColor: UIColor?) {
        let labelHeadertitle           = UILabel()
        labelHeadertitle.frame         = topTitleLabelFrame
        labelHeadertitle.text          = title
        labelHeadertitle.font          = titleFont
        labelHeadertitle.textAlignment = .center
        labelHeadertitle.textColor     = titleTextColor ?? UIColor(colorConfig.navigation_header_color!)
        headerTitle = labelHeadertitle
        addSubview(headerTitle!)
    }
    
    //------------------------------------------------------------------
    
    public func showLeftButtonWithTitle(leftButtonConfig: NavButtonConfig) {
        let addButton = UIButton(type: .custom)
        addButton.frame = leftButtonConfig.frame!
        addButton.tag = leftButtonConfig.tag ?? 0
        if leftButtonConfig.image != nil {
            addButton.backgroundColor = leftButtonConfig.backgroundColor
            addButton.setImage(image: leftButtonConfig.image, tintColor: leftButtonConfig.imageTintColor, forUIControlState: UIControl.State.normal)
            self.leftButton = addButton
        } else {
            addButton.setTitle(leftButtonConfig.title, for: UIControl.State.normal)
            addButton.setTitleColor(leftButtonConfig.textColor, for: UIControl.State.normal)
            addButton.backgroundColor = leftButtonConfig.backgroundColor
            addButton.titleLabel?.font = leftButtonConfig.font
            self.leftButton = addButton
        }
        self.leftButton?.addTarget(self, action: #selector(leftButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
        addSubview(self.leftButton!)
    }
    
    //------------------------------------------------------------------
    
    public func showRightButtonWithTitle(arrRightButtonConfig: [NavButtonConfig]) {
        for i in 0..<arrRightButtonConfig.count {
            let addButton = UIButton(type: .custom)
            addButton.frame = arrRightButtonConfig[i].frame ?? topLeftButtonFrame
            addButton.tag = arrRightButtonConfig[i].tag ?? 0
            if arrRightButtonConfig[i].image != nil {
                addButton.backgroundColor = arrRightButtonConfig[i].backgroundColor
                addButton.setImage(image: arrRightButtonConfig[i].image, tintColor: arrRightButtonConfig[i].imageTintColor, forUIControlState: UIControl.State.normal)
                rightButton = addButton
            } else {
                addButton.setTitle(arrRightButtonConfig[i].title, for: UIControl.State.normal)
                addButton.setTitleColor(arrRightButtonConfig[i].textColor, for: UIControl.State.normal)
                addButton.backgroundColor = arrRightButtonConfig[i].backgroundColor
                addButton.titleLabel?.font = arrRightButtonConfig[i].font
                rightButton = addButton
                
            }
            rightButton?.addTarget(self, action: #selector(rightButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
            addSubview(rightButton!)
        }
    }
    
    public func hideRightButton() {
        rightButton?.isHidden = true
    }
    public func showRightButton() {
        rightButton?.isHidden = false
    }
    
    public func setLeftButtonColor(color: UIColor) {
        leftButton?.tintColor = color
    }
    
    public func setRightButtonImage(image: UIImage, tintColor: UIColor) {
        rightButton?.setImage(image: image, tintColor: tintColor, forUIControlState: UIControl.State.normal)
    }
    
    //------------------------------------------------------------------
    
    @objc func leftButtonTapped(sender: UIButton) {
        self.delegate?.leftButtonAction(button: sender)
    }
    
    //------------------------------------------------------------------
    
    @objc func rightButtonTapped(sender: UIButton) {
        self.delegate?.rightButtonAction(button: sender)
    }
    
    //------------------------------------------------------------------
    
}
