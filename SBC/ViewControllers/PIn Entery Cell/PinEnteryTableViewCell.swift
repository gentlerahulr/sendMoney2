//
//  PinEnteryTableViewCell.swift
//  SBC
//

import UIKit

struct PinEnteryTableViewCellConfig: BaseCellConfig {
    var backgroundColor: UIColor?
    var insets: UIEdgeInsets?
    var strlabelTitle: String?
    var strlabelDesc: String?
    var strLableContact: String?
    var strLableShowError: String?
    var strBtn: String?
    var resendImageName: String = ""
    var shouldSecureText: Bool = true
}

protocol PinEnteryTableViewCellDelegate: AnyObject {
    
}
class PinEnteryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var lableContact: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var lableShowError: UILabel!
    @IBOutlet weak var buttonResend: ButtonWithRightImage!
    
    @IBOutlet weak var buttonResendTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    var didPinEntered: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupOTPTextHandlerView()
        selectionStyle = .none
    }
    
    func configureCell(config: PinEnteryTableViewCellConfig) {
        
        let regularFont = UIFont.regularFontWithSize(size: 16)
        setUpLabelProperties(label: labelTitle, font: .boldFontWithSize(size: 22), textColor: .themeDarkBlue, text: config.strlabelTitle, textAlignment: .center)
        setUpLabelProperties(label: labelDesc, font: regularFont, textColor: .themeLightBlue, text: config.strlabelDesc, textAlignment: .left)
        setUpLabelProperties(label: lableContact, font: regularFont, textColor: .themeLightBlue, text: config.strLableContact, textAlignment: .left)
        setUpLabelProperties(label: lableShowError, font: regularFont, textColor: .themeRed, text: config.strLableShowError, textAlignment: .center)
        
        if let btnStr = config.strBtn {
            buttonResend.isHidden = false
            if btnStr == localizedStringForKey(key: "button.title.forgot_your_pin") {
                imgView.isHidden = true
            } else {
                imgView.isHidden = false
            }
        } else {
            buttonResend.isHidden = true
            imgView.isHidden = true
        }
      
        setResendButton(title: config.strBtn, font: regularFont, image: UIImage(named: config.resendImageName))
        pinView.shouldSecureText = config.shouldSecureText
    }
    
    private func setUpLabelProperties(label: UILabel, font: UIFont, textColor: UIColor, text: String?, textAlignment: NSTextAlignment?) {
        label.font = font
        label.textColor = textColor
        label.text = text
        label.textAlignment = textAlignment ?? .left
    }
    
    private func setResendButton(title: String?, font: UIFont? = nil, image: UIImage?) {
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.themeDarkBlue]
        let attributedButtonText = NSAttributedString(string: title ?? "", attributes: attributes as [NSAttributedString.Key: Any])
        buttonResend.setAttributedTitle(attributedButtonText, for: .normal)
        buttonResend.setImage(image, for: .normal)
    }
    
    private func setupOTPTextHandlerView() {
        pinView.pinLength = 6
        pinView.interSpace = 10
        pinView.textColor = .themeDarkBlue
        pinView.borderLineColor = .themeLightBlue
        pinView.activeBorderLineColor = .themeDarkBlue
        pinView.borderLineThickness = 4
        pinView.activeBorderLineThickness = 4
        pinView.keyboardAppearance = .default
        pinView.tintColor = .white
        pinView.shouldSecureText = false
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        pinView.font = UIFont.boldFontWithSize(size: 38)
        pinView.keyboardType = .numberPad
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            self.lableShowError.isHidden = true
        }
    }
    
    func didFinishEnteringPin(pin: String) {
        didPinEntered?(pin)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
