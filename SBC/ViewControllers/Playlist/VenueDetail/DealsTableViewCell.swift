import UIKit

class DealsTableViewCell: UITableViewCell {

    @IBOutlet weak var borderedView: UIView!
    @IBOutlet weak var dealTypeImageView: UIImageView!
    @IBOutlet weak var dealLogoImageView: UIImageView!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealExpiryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configureWith(deal: Deal) {
        if let expiryDate = deal.expiryDate {
            dealExpiryLabel.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dealExpiryLabel.text = "Expires \(dateFormatter.string(from: expiryDate))"
        } else {
            dealExpiryLabel.isHidden = true
        }
        dealTitleLabel.text = deal.name
        if let logo = deal.providerIconUrl {
            dealLogoImageView.downloaded(from: logo)
        }
        dealTypeImageView.image = UIImage(named: deal.expiryDate != nil ? "coreIconClock" : "coreIconCategory")
    }

    private func setupUI() {
        borderedView.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
        borderedView.layer.borderWidth = 2
        borderedView.layer.cornerRadius = 8
        
        dealTitleLabel.setLabelConfig(lblConfig: LabelConfig.getMediumLabelConfig(text: "", numberOfLines: 0))
        dealExpiryLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: "", fontSize: 12, textColor: UIColor.themeDarkBlueTint1))
        dealTypeImageView.backgroundColor = UIColor.themeNeonGreen
    }
    
}
