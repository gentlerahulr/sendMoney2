//
//  ActionPopup.swift
//  SBC

import UIKit

class ActionPopup: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupContainerView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonPositive: UIButton!
    @IBOutlet weak var buttonNegative: UIButton!
    
    var addPositiveButtonAction: (() -> Void)?
    var addNegativeButtonction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup view from .xib file
        configureXIB()
    }
    
    //------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Setup view from .xib file
        configureXIB()
    }
    
    func configureXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        addSubview(view)
    }
    
    func setUpFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        buttonNegative.imageView?.contentMode = .scaleAspectFill
    }
    
    func setActionPopupConfig(popupConfig: ActionPopupViewConfig, showOnFullScreen: Bool) {
        
        if popupConfig.style == .bottomSheet {
            self.popupContainerView.removeFromSuperview()
            self.containerView.addSubview(self.popupContainerView)
            self.popupContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            self.containerStackView.removeFromSuperview()
            self.popupContainerView.addSubview(self.containerStackView)
            self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.popupContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.popupContainerView.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.popupContainerView.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.popupContainerView.leadingAnchor.constraint(equalTo: self.containerStackView.leadingAnchor, constant: -16),
                self.popupContainerView.trailingAnchor.constraint(equalTo: self.containerStackView.trailingAnchor, constant: 16),
                self.popupContainerView.topAnchor.constraint(equalTo: self.containerStackView.topAnchor, constant: -32),
                self.popupContainerView.bottomAnchor.constraint(equalTo: self.containerStackView.bottomAnchor, constant: 32.0 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            ])
            
            self.popupContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            
            self.popupContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        labelTitle.setLabelConfig(lblConfig: popupConfig.labelTitleConfig)
        labelDescription.setLabelConfig(lblConfig: popupConfig.labelDescConfig)
        buttonNegative.setButtonConfig(btnConfig: popupConfig.buttonNegativeConfig)
        buttonPositive.setButtonConfig(btnConfig: popupConfig.buttonPositiveConfig)
        buttonNegative.isHidden = popupConfig.hideNegativeButton
        if showOnFullScreen {
            setUpFrame()
        }
    }
    
    @IBAction func positiveButtonAction(_ sender: UIButton) {
        addPositiveButtonAction?()
        self.removeFromSuperview()
    }
    
    @IBAction func negativeButtonAction(_ sender: UIButton) {
        addNegativeButtonction?()
        self.removeFromSuperview()
    }
    
}

/*
 //Declare Global Property
 private func showActionPopup(parentView: UIView) {
    let actionPopupView = ActionPopup()
    let text = ActionPopupViewConfig.Text(titleText: "Are you sure?", descText: "If you go back now, your registration will be cancelled and progress lost. You will need to start over again if you decide to register the wallet.", positiveButtonText: "Yes, cancel registration", negativeButtonText: "Stay and Continue")
    let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeRed, hideNegativeButton: false)
 actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: false)
    actionPopupView.addPositiveButtonAction  = { [weak self] in
        debugPrint("Callback Positive Called.")
        self?.navigationController?.popViewController(animated: true)
    }
    actionPopupView.addNegativeButtonction = { [weak self] in
        debugPrint("Callback Negative Called.")
    }
    parentView.addSubview(actionPopupView)
 }
 
 */
