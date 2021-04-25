//
//  ManageWalletPersonalInfoCell.swift
//  SBC
//

import UIKit

class ManageWalletPersonalInfoCell: UITableViewCell {

    @IBOutlet weak var personalInfoTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mobileNumberTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var registerAddressTitleLabel: UILabel!
    @IBOutlet weak var updateMobileNoButton: UIButton!
    @IBOutlet weak var registerAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ManageWalletPersonalInfoCell {
    func setupViews() {
        containerView.setBorderWithColor(borderColor: #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9607843137, alpha: 1), borderWidth: 2, cornerRadius: 8)
    }
}
