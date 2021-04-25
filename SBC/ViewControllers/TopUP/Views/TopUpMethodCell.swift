//
//  TopUpMethodCell.swift
//  SBC
//

import UIKit

protocol TopUpMethodDelegate: AnyObject {
    func topUpMethod(didSelect method: TopUpMethod, view: TopUpMethodCell)
}

class TopUpMethodCell: UITableViewCell {
    
    @IBOutlet weak var payNowButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    
    weak var delegate: TopUpMethodDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.payNowButton.isSelected = true
        self.cardButton.isSelected = false
    }
    
    @IBAction private func PayNow_Tapped(_ sender: UIButton) {
        
        guard sender.isSelected == false else {
            return
        }
        self.payNowButton.isSelected = true
        self.cardButton.isSelected = false
        self.delegate?.topUpMethod(didSelect: .pay_now, view: self)
    }
    
    @IBAction private func Card_Tapped(_ sender: UIButton) {
        guard sender.isSelected == false else {
            return
        }
        self.payNowButton.isSelected = false
        self.cardButton.isSelected = true
        self.delegate?.topUpMethod(didSelect: .card, view: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
}
