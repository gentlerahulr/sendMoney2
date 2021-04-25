//
//  ButtonTableViewCell.swift
//  SBC

//

import UIKit
struct ButtonTableViewCellConfig {
    var inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    
    var buttonBackgroundColor: UIColor  = UIColor.red
    var buttonTextColor: UIColor  = UIColor.white
    var buttonFont: UIFont  = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var borderColor: UIColor = UIColor.red
    var borderWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var enabledButton: Bool = false
}

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnAction: UIButton!
    
    private var uiConfig: ButtonTableViewCellConfig = ButtonTableViewCellConfig()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureViewModel(model: ButtonTableViewCellConfig) {
        self.uiConfig = model
        setUpUI()
    }
    
    func configure(title: String?) {
        setUpUI()
        self.btnAction.setTitle(title, for: UIControl.State.normal)
    }
    
    func configure(title: NSAttributedString?) {
        
        setUpUI()
        self.btnAction.setAttributedTitle(title, for: .normal)
    }
    
    // MARK: Private
    private func setUpUI() {
        if uiConfig.enabledButton {
             btnAction.backgroundColor = uiConfig.buttonBackgroundColor
        } else {
             btnAction.backgroundColor = uiConfig.buttonBackgroundColor
        }
       
        btnAction.setTitleColor(uiConfig.buttonTextColor, for: UIControl.State.normal)
        btnAction.titleLabel?.font = uiConfig.buttonFont
        leadingConstraint.constant = uiConfig.inset.left
        trailingConstraint.constant = uiConfig.inset.right
        topConstraint.constant = uiConfig.inset.top
        bottomConstraint.constant = uiConfig.inset.bottom
//        btnAction.addShadow(withHeight: 2, radius: 2, isDark: true)
        btnAction.setBorderWithColor(borderColor: uiConfig.borderColor, borderWidth: uiConfig.borderWidth, cornerRadius: uiConfig.cornerRadius)
    }
    
    @IBAction func btnActionClicked(_ sender: Any) {
    }
    
    func clearBgColor() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}
