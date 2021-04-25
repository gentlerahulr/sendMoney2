//
//  CustomTextfieldView.swift
//  SBC
//

import UIKit

struct MWCustomTextfieldColorConstants {
    static let borderColor = UIColor.themeRed
    static let textColor = UIColor.themeRed
    static let normalColor = UIColor.themeLightBlue
    static var editingColor = UIColor.themeLightBlue
    static let errorColor: UIColor  = UIColor.themeRed
}

public class CustomTextfieldView: UIView {
    let kCONTENT_XIB_NAME = "CustomTextfieldView"
    @IBOutlet var containerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var lblError: UILabel!

    private var currentState: FieldState = FieldState.normal

    enum FieldState {
        case normal
        case editing
        case error
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        setUpTextfield()
        setUpBorder()
        hideError()
    }
    
    private func setUpTextfield() {
        textfield.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        placeholder.text = textfield.placeholder
        AppManager.appStyle.apply(textStyle: AppManager.TextStyle.inputText, to: placeholder)
    }
    
    private func setUpBorder() {
        borderView.backgroundColor = UIColor.clear
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.themeLightBlue.cgColor
        borderView.layer.cornerRadius = 5.0
    }
    
    func setInputView(view: UIView) {
        self.textfield.inputView = view
    }
    
    func setInputAccessoryView(view: UIView) {
        self.textfield.inputAccessoryView = view
    }
    
    func updateBackgroundColor(color: UIColor) {
        self.backgroundColor = color
        self.containerView.backgroundColor = color
        self.borderView.backgroundColor = color
        self.contentView.backgroundColor = color
        self.textfield.backgroundColor = color
        self.lblError.backgroundColor = color
        self.placeholder.backgroundColor = color
    }
    
    func updatePlaceholder(placeHolder: String) {
        placeholder.text = placeHolder
        textfield.placeholder = placeHolder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.themeDarkBlue,
                          NSAttributedString.Key.font: UIFont.regularFontWithSize(size: 16)]

        textfield.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                               attributes: attributes)
    }
    
    func showError(str: NSAttributedString) {
        lblError.isHidden = false
        lblError.attributedText = str
    }
    
    func hideError() {
        lblError.isHidden = true
        lblError.attributedText = NSAttributedString(string: "No error")
    }
    
    // MARK: Field states
    private func setNormalState() {
        self.lblError.text = ""
        borderView.setBorderWithColor(borderColor: MWCustomTextfieldColorConstants.normalColor)
        placeholder.textColor = MWCustomTextfieldColorConstants.editingColor

        hideError()
    }
    
    private func setEditingState() {
        borderView.setBorderWithColor(borderColor: MWCustomTextfieldColorConstants.editingColor)
        placeholder.textColor = MWCustomTextfieldColorConstants.editingColor
        hideError()
    }
    
    private func setErrorState() {
        borderView.setBorderWithColor(borderColor: MWCustomTextfieldColorConstants.errorColor)
        configureError(error: "Unknown Error")
    }
    
    // MARK: - left right panel
    
    func addRightButton(image: UIImage, selecteImage: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("", for: UIControl.State.normal)
        button.setImage(image, for: .normal)
        
        if let selected = selecteImage {
            button.setImage(selected, for: .selected)
        }
        button.frame = CGRect(x: 0, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        textfield.rightView = button
        textfield.rightViewMode = .always
        return button
    }
    
    func addLeftButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.tintColor = UIColor.black
        button.setTitle(title, for: UIControl.State.normal)
        button.frame = CGRect(x: 0, y: CGFloat(0), width: CGFloat(40), height: self.textfield.bounds.height)
        button.setTitleColor(textfield.textColor, for: UIControl.State.normal)
        textfield.leftView = button
        textfield.leftViewMode = .always
        return button
    }
    
    func setText(text: String?) {
        guard let passed = text, !passed.isEmpty else {
            placeholder.isHidden = true
            joinTheBorder()
            textfield.text = text
            return
        }
        textfield.text = passed
//        cutTheBorder()
        placeholder.isHidden = false
    }
    
    @objc func rightPannelTaped(_ sender: Any) {
        
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        guard let text = textfield.text, !text.isEmpty else {
            placeholder.isHidden = true
            joinTheBorder()
            return
        }
//        cutTheBorder()
        return placeholder.isHidden = false
    }
    
    func setText(text: String) {
        if text.length() > 0 {
            self.textfield.text = text
//            cutTheBorder()
            placeholder.isHidden = false
        } else {
            placeholder.isHidden = true
            joinTheBorder()
        }
    }

    private func cutTheBorder() {
        let path = CGMutablePath()
        path.addRect(CGRect(x: 8, y: 0, width: self.placeholder.intrinsicContentSize.width+5, height: 4))
        path.addRect(CGRect(origin: .zero, size: borderView.bounds.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.red.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        borderView.layer.mask = maskLayer
        borderView.clipsToBounds = true
        
        placeholder.textColor = MWCustomTextfieldColorConstants.editingColor
    }
    
    private func joinTheBorder() {
        borderView.setBorderWithColor(borderColor: MWCustomTextfieldColorConstants.normalColor)
        borderView.layer.mask = nil
    }
    
    func getCurrentState() -> FieldState {
        return currentState
    }

    func setState(state: FieldState) {
        currentState = state
        switch state {
        case .normal:
            setNormalState()
            break
        case .editing:
            setEditingState()
            break
        case .error:
            setErrorState()
            break
        }
    }
    
    func getText() -> String? {
        return textfield.text
    }
    
    func configureRightPanel(rightButton: UIView) {
        self.textfield.rightViewMode = .always
        rightButton.frame = CGRect.init(x: rightButton.frame.origin.x, y: rightButton.frame.height - 30, width: rightButton.frame.width, height: 30)
        self.textfield.rightView = rightButton
    }
    
    func configureLeftPanell(leftButton: UIView) {
        self.textfield.leftViewMode = .always
        leftButton.frame = CGRect.init(x: leftButton.frame.origin.x, y: 10, width: leftButton.frame.width, height: 30)
        self.textfield.leftView = leftButton
    }
    
    func configureLeftPanel(leftButton: UIButton) {
        self.textfield.leftViewMode = .always
        leftButton.frame = CGRect.init(x: leftButton.frame.origin.x, y: leftButton.frame.height - 30, width: leftButton.frame.width, height: 30)
        self.textfield.leftView = leftButton
    }
    
    func configureError(error: String, errorColor: UIColor = MWCustomTextfieldColorConstants.errorColor) {
        self.lblError.isHidden = false
        self.lblError.font = UIFont.regularFontWithSize(size: 13)
        self.lblError.textColor = UIColor.red
        self.lblError.text = error
    }
}
