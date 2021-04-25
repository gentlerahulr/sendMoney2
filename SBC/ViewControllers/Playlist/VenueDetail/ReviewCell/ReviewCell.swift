//
//  ReviewCell.swift
//  SBC
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var reviewSourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var borderedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderedView.layer.borderWidth = 2
        borderedView.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
        borderedView.layer.cornerRadius = 8
        
        reviewSourceLabel.font = .mediumFontWithSize(size: 16)
        reviewSourceLabel.textColor = .themeDarkBlue
        dateLabel.font = .regularFontWithSize(size: 12)
        dateLabel.textColor = .themeDarkBlueTint1
        ratingLabel.font = .boldSystemFont(ofSize: 12)
        ratingLabel.textColor = .themeDarkBlue
    }
    
    func configureWith(review: Review) {
        reviewSourceLabel.text = review.source
        
        if let lastDate = review.updated {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd MMM YYYY"
            let lastUpdated = "reviews_last_updated".localized(bundle: Bundle.main)
            dateLabel.text =  "\(lastUpdated) \(dateFormat.string(from: lastDate))"
        } else {
            dateLabel.text = ""
        }
        ratingLabel.text = "\(review.rating)"
    }
    
}
