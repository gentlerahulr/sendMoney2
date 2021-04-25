//
//  LandingViewEmptyView.swift
//  SBC
//

import UIKit

class YourLikesEmptyView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldFontWithSize(size: 22)
        titleLabel.textColor = .themeDarkBlue
        titleLabel.text = "YOUR_LIKES_EMPTY_TITLE".localized(bundle: Bundle.main)
        descriptionLabel.font = UIFont.regularFontWithSize(size: 16)
        descriptionLabel.textColor = .themeDarkBlue
        descriptionLabel.text = "YOUR_LIKES_EMPTY_DESC".localized(bundle: Bundle.main)
        
        let btnConfig = ButtonConfig.getBackgroundButtonConfig(titleText: "YOUR_LIKES_EMPTY_BUTTON".localized(bundle: Bundle.main), fontSize: 16, textColor: .themeDarkBlue, backgroundColor: .themeNeonBlue, cornerRadius: 8)
        actionButton.setButtonConfig(btnConfig: btnConfig)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        buttonAction?()
    }

}
