//
//  TittleWithDescriptionTableViewCell.swift
//  SBC
//

import UIKit

struct TittleWithDescriptionTableViewCellConfig: BaseCellConfig {
    var insets: UIEdgeInsets?
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var titleColor: UIColor?
    var descriptionColor: UIColor?
    var titleFont: UIFont?
    var descriptionFont: UIFont?
    
}

class TittleWithDescriptionTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var containerLables: UIView!
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var lblFourth: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var trallingConstarint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstarint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstarint: NSLayoutConstraint!
    var strTittle: String?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// This method will configure cell for email textfield
    func configureEmailCell() {
        var config = TittleWithDescriptionTableViewCellConfig()
        config.insets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        self.lblTittle.text = self.strTittle
        self.lblTittle.textColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
        self.lblTittle.font = UIFont.boldFontWithSize(size: 22)
        self.containerLables.isHidden = true
        self.heightConstraint.constant = 0
        self.selectionStyle = .none
    }

    /// This method will configure cell for Validation Rule instruction
    func configureValidationRuleCell() {
        var config = TittleWithDescriptionTableViewCellConfig()
        config.insets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        self.lblTittle.text = ""
        self.lblOne.text = localizedStringForKey(key: "PEASE_ENSURE_PASSWORD")
        self.lblOne.textColor = UIColor((colorConfig.primary_background_color!)!)
        self.lblOne.font = UIFont.regularFontWithSize(size: 13)
        self.lblSecond.text = localizedStringForKey(key: "AT_Least_8_CHARATER_LONG")
        self.lblSecond.textColor = UIColor((colorConfig.primary_background_color!)!)
        self.lblSecond.font = UIFont.regularFontWithSize(size: 13)
        self.lblThird.text = localizedStringForKey(key: "AT_Least_1_LOWER_CASE")
        self.lblThird.textColor = UIColor((colorConfig.primary_background_color!)!)
        self.lblThird.font = UIFont.regularFontWithSize(size: 13)
        self.lblFourth.text = localizedStringForKey(key: "AT_Least_1_UPPER_CASE")
        self.lblFourth.textColor = UIColor((colorConfig.primary_background_color!)!)
        self.lblFourth.font = UIFont.regularFontWithSize(size: 13)
        self.selectionStyle = .none
    }
    
    /// This method will configure cell for Tittle and Desctription
    func configurePasswordRecovryCell() {
        var config = TittleWithDescriptionTableViewCellConfig()
        config.insets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        self.lblTittle.text = localizedStringForKey(key: "PASSWORD_RECOVERY_TITTLE")
        self.lblTittle.textColor = UIColor.getUIColorFromHexCode(colorCode: ColorHex.ThemeDarkBlue, alpha: 1.0)
          self.lblTittle.font = UIFont.boldFontWithSize(size: 22)
        let lblOneConfig = LabelConfig.getRegularLabelConfig(text: localizedStringForKey(key: "PASSWORD_RECOVERY_DESCRIPTION"), lineSpacing: 2.5)
        self.lblOne.setLabelConfig(lblConfig: lblOneConfig)
        self.lblSecond.isHidden = true
        self.lblFourth.isHidden = true
        self.lblThird.isHidden = true
        self.heightConstraint.constant = 80
        self.selectionStyle = .none
    }
    
    func configureAcceptMobileNumberCell(title: String, desc: String) {
        var config = TittleWithDescriptionTableViewCellConfig()
        config.insets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        let lblTitleConfig = LabelConfig.getBoldLabelConfig(text: title)
        self.lblTittle.setLabelConfig(lblConfig: lblTitleConfig)
         let lblOneConfig = LabelConfig.getRegularLabelConfig(text: desc)
        self.lblOne.setLabelConfig(lblConfig: lblOneConfig)
        self.lblSecond.isHidden = true
        self.lblFourth.isHidden = true
        self.lblThird.isHidden = true
        self.heightConstraint.constant = 80
        self.selectionStyle = .none
    }
    
    func configTittleWithDescriptionTableViewCell(config: TittleWithDescriptionTableViewCellConfig ) {
        if let insets = config.insets {
            bottomConstarint.constant = insets.bottom
            topConstraint.constant = insets.top
            leadingConstarint.constant = insets.right
            trallingConstarint.constant = insets.left
        }
    }
    
}
