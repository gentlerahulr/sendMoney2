//
//  DropDownCellTableViewCell.swift
//  SBC
//

import UIKit

open class DropDownCell: UITableViewCell {
		
	//UI
	@IBOutlet open weak var optionLabel: UILabel!
    @IBOutlet open weak var separatorView: UIView!
    
	var selectedBackgroundColor: UIColor?
    var highlightTextColor: UIColor?
    var normalTextColor: UIColor?
    var selectedFont: UIFont?
    var normalFont: UIFont?

}

// MARK: UI
extension DropDownCell {
	
	override open func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = .clear
	}
	
	override open var isSelected: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override open var isHighlighted: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
		setSelected(highlighted, animated: animated)
	}
	
	override open func setSelected(_ selected: Bool, animated: Bool) {
		let executeSelection: () -> Void = { [weak self] in
			guard let `self` = self else { return }

			if let selectedBackgroundColor = self.selectedBackgroundColor {
				if selected {
					self.backgroundColor = selectedBackgroundColor
                    self.optionLabel.textColor = self.highlightTextColor
                    self.optionLabel.font = self.selectedFont
				} else {
					self.backgroundColor = .clear
                    self.optionLabel.textColor = self.normalTextColor
                    self.optionLabel.font = self.normalFont
				}
			}
		}
		
		if animated {
			UIView.animate(withDuration: 0.3, animations: {
				executeSelection()
			})
		} else {
			executeSelection()
		}

		accessibilityTraits = selected ? .selected : .none
	}
	
}
