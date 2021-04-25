//
//  CardCollectionViewCell.swift
//  SBC
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var cvvNumberLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var showAndHideButton: UIButton!
    @IBOutlet weak var cardSubDetailContainerView: UIView!
    @IBOutlet weak var cardBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
