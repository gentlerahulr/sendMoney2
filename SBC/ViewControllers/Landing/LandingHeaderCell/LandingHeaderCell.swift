//
//  LandingHeaderCell.swift
//  SBC
//

import UIKit

class LandingHeaderCell: UITableViewHeaderFooterView {
    
    static let nib = String(describing: LandingHeaderCell.self)

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var likeButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subtitleLabel.text = "FOOD_DRINKS".localized(bundle: Bundle.main)
        titleLabel.text = "EXPLORE_SINGAPORE".localized(bundle: Bundle.main)
        subtitleLabel.textColor = UIColor.themeWhite
        titleLabel.textColor = UIColor.themeNeonBlue
        subtitleLabel.font = UIFont.regularFontWithSize(size: 12)
        titleLabel.font = UIFont.boldFontWithSize(size: 20)
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        likeButton.clipsToBounds = true
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButtonAction?()
    }
    
}
