//
//  TopUpQRCodeTableViewCell.swift
//  SBC
//

import UIKit

class TopUpQRCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var scanCodeMessageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mobileNumCopyButton: UIButton!
    @IBOutlet weak var uenCopyButton: UIButton!
    @IBOutlet weak var uenValueLabel: UILabel!
    @IBOutlet weak var amountCopyButton: UIButton!
    @IBOutlet weak var referenceCodeCopyButton: UIButton!
    @IBOutlet weak var referenceCodeToolTipButton: UIButton!
    @IBOutlet weak var downloadQRcodeButton: UIButton!
    @IBOutlet weak var currenyCodeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var referanceCodeTitleLabel: UILabel!
    @IBOutlet weak var referanceCodeLabel: UILabel!
    @IBOutlet weak var copyPasteMessageLabel: UILabel!
    @IBOutlet var designView: [UIView]!
    @IBOutlet weak var dashLineView: UIView!
    @IBOutlet weak var QRCodeView: UIView!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var toltipButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var backToWalletButton: UIButton!
    @IBOutlet weak var toolTipBackgroundImageView: UIImageView!
    @IBOutlet weak var toolTipMessageLabel: UILabel!
    
    let textTitleColor = #colorLiteral(red: 0.09019607843, green: 0.1450980392, blue: 0.3254901961, alpha: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension TopUpQRCodeTableViewCell {
    func setupView() {
        for views in designView {
            views.setCorner(12)
        }
        containerView.setCorner(10)
        uenValueLabel.textColor = textTitleColor
        amountLabel.textColor = textTitleColor
        referanceCodeLabel.textColor = textTitleColor
        copyPasteMessageLabel.textColor = textTitleColor
        downloadQRcodeButton.setTitleColor(textTitleColor, for: .normal)
        backToWalletButton.setCorner(10)
        
    }
    
    func setData(QRCodeString: String) {
        if let decodedData = Data(base64Encoded: QRCodeString, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            QRCodeImageView.image = image
        }
        
    }
}
