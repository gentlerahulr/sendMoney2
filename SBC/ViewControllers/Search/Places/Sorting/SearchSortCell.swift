//
//  PlacesSortCell.swift
//  SBC
//

import UIKit

class SearchSortCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .regularFontWithSize(size: 16)
        titleLabel.textColor = .themeDarkBlue
    }

    func setSortItem(_ item: SortItem, showSeparatorLine: Bool) {
        titleLabel.text = item.title
        checkmarkImageView.isHidden = !item.isSelected
        separatorLine.isHidden = !showSeparatorLine
    }
}
