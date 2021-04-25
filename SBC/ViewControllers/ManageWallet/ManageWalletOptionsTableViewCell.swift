import UIKit

class ManageWalletOptionsTableViewCell: UITableViewCell {
    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var disclosureIconImageView: UIImageView!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ManageWalletOptionsTableViewCell {
    func setupViews() {
        conatinerView.setBorderWithColor(borderColor: .themeDarkBlueTint3, borderWidth: 2, cornerRadius: 8)
    }
}
