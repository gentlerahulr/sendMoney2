//
//  TextfieldTableViewCell.swift
//  SBC
//

import UIKit

struct TextfieldTableViewCellConfig: BaseCellConfig {
    var insets: UIEdgeInsets?
    var backgroundColor: UIColor?
    var placeHolder: String?
    var text: String?
    var textColor: UIColor = .themeDarkBlue
    var enable: Bool?
}

struct ContainerViewConfig: BaseCellConfig {
    var insets: UIEdgeInsets?
    var backgroundColor: UIColor?
    var enable: Bool?
}

class TextfieldTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textfield: CustomTextfieldView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle =  .none
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configContainerView(configView: ContainerViewConfig? ) {
        if let insets = configView?.insets {
            bottom.constant = insets.bottom
            top.constant = insets.top
            trailing.constant = insets.right
            leading.constant = insets.left
        }
    }
    
    func configureCell(config: TextfieldTableViewCellConfig?) {
        if let insets = config?.insets {
            viewBottom.constant = insets.bottom
            viewTop.constant = insets.top
            viewTrailing.constant = insets.right
            viewLeading.constant = insets.left
        }
        DispatchQueue.main.async {
            
            if let placeHolder = config?.placeHolder {
                
                self.textfield.updatePlaceholder(placeHolder: placeHolder)
                
            }
            
            if let bgColor = config?.backgroundColor {
                self.textfield.backgroundColor = bgColor
                self.textfield.updateBackgroundColor(color: bgColor)
            }
            
            self.textfield.textfield.textColor = config?.textColor
            self.textfield.textfield.font = UIFont.regularFontWithSize(size: 16)
            
            if let enable = config?.enable {
                self.textfield.textfield.isEnabled = enable
                if enable {
                    self.textfield.textfield.textColor = config?.textColor
                } else {
                    self.textfield.textfield.textColor = config?.textColor.withAlphaComponent(0.50)
                }
            }
            
            if let text = config?.text {
                self.textfield.setText(text: text)
            }
        }

    }
    
    func changeStateForTextField(configValue: Bool) {
        if !configValue {
            self.textfield.borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
}
