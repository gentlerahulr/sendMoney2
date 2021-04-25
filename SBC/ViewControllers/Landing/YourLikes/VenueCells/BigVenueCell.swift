//
//  BigVenueCell.swift
//  SBC
//

import UIKit

class BigVenueCell: UITableViewCell {

    @IBOutlet private weak var dealsView: UIView!
    @IBOutlet private weak var dealsLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet private weak var venueTitleLabel: UILabel!
    @IBOutlet private weak var venueInfosLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    var addVenueAction: (() -> Void)?
    var likeVenueAction: (() -> Void)?
    
    private var venue: Venue?
    private var recommendation: Recommendation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        dealsLabel.setLabelConfig(lblConfig: LabelConfig.getMediumLabelConfig(text: "venue_deals".localized(bundle: Bundle.main), fontSize: 13))
        dealsView.backgroundColor = .themeNeonGreen
        gradientView.applyDiagonalGradient(colours: [UIColor((colorConfig.primary_background_color!)!)!, UIColor((colorConfig.primary_background_color!)!)!.withAlphaComponent(0)])
        venueTitleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: "", fontSize: 20))
        venueInfosLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: "", fontSize: 13, textColor: .themeDarkBlueTint1))
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        addVenueAction?()
    }
    
    @IBAction private func likeTapped(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        let toAdd = likeButton.isSelected ? 1 : -1
        if let venue = venue {
            let newLikeCount = "\(venue.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        } else if let recommendation = recommendation {
            let newLikeCount = "\(recommendation.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        }
        likeVenueAction?()
    }
    
    func configureWithVenue(venue: Venue) {
        dealsView.isHidden = !(venue.hasDeals ?? false)
        likeButton.setTitle("\(venue.likeCount)", for: .normal)
        likeButton.isSelected = venue.isLiked
        venueImageView.downloaded(from: venue.imageUrl, placeholder: UIImage(named: "venuePlaceholder"))
        venueTitleLabel.text = venue.name
        venueInfosLabel.attributedText = createTagsLabel(venue: venue)
        self.venue = venue
    }
    
    private func createTagsLabel(venue: Venue) -> NSAttributedString {
        let attributedText: NSMutableAttributedString
        if let starRating = venue.starRating, starRating > 0.0 {
            let ratingImage = NSTextAttachment()
            ratingImage.image = UIImage(named: "coreIconRateFill")
            let imageOffsetY: CGFloat = -3.5
            ratingImage.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
            attributedText = NSMutableAttributedString(attachment: ratingImage)
            attributedText.append(NSAttributedString(string: String(starRating), attributes: [
                .font: UIFont.boldFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlue
            ]))
            if let reviewCount = venue.reviewCount, reviewCount > 0 {
                attributedText.append(NSAttributedString(string: " (\(reviewCount))", attributes: [
                    .font: UIFont.regularFontWithSize(size: 13),
                    .foregroundColor: UIColor.themeDarkBlue
                ]))
            }
            attributedText.append(NSAttributedString(string: " • ", attributes: [
                .font: UIFont.regularFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlueTint1
            ]))
        } else {
            attributedText = NSMutableAttributedString()
        }
        var tags = [String]()
      
        if venue.priceBracket > 0 {
            let price = String(repeating: "$", count: Int(venue.priceBracket))
            tags.append(price)
        }
        if let category = venue.category {
            tags.append(category)
        }
        if let area = venue.area {
            tags.append(area)
        }
        attributedText.append(NSAttributedString(string: tags.joined(separator: " • "), attributes: [
            .font: UIFont.regularFontWithSize(size: 13),
            .foregroundColor: UIColor.themeDarkBlueTint1
        ]))
        return attributedText
    }
    
    func configureWithRecommendation(recommendation: Recommendation) {
        dealsView.isHidden = recommendation.hasDeals
        likeButton.setTitle("\(recommendation.likeCount)", for: .normal)
        likeButton.isSelected = recommendation.isLiked
        venueImageView.downloaded(from: recommendation.imageURL, placeholder: UIImage(named: "venuePlaceholder"))
        venueTitleLabel.text = recommendation.name
        venueInfosLabel.attributedText = createTagsLabel(recommendation: recommendation)
        self.recommendation = recommendation
    }
    
    private func createTagsLabel(recommendation: Recommendation) -> NSAttributedString {
        let attributedText: NSMutableAttributedString
        if let starRating = recommendation.starRating, starRating > 0.0 {
            let ratingImage = NSTextAttachment()
            ratingImage.image = UIImage(named: "coreIconRateFill")
            let imageOffsetY: CGFloat = -3.5
            ratingImage.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
            attributedText = NSMutableAttributedString(attachment: ratingImage)
            attributedText.append(NSAttributedString(string: String(starRating), attributes: [
                .font: UIFont.boldFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlue
            ]))
            if let reviewCount = recommendation.reviewCount, reviewCount > 0 {
                attributedText.append(NSAttributedString(string: " (\(reviewCount))", attributes: [
                    .font: UIFont.regularFontWithSize(size: 13),
                    .foregroundColor: UIColor.themeDarkBlue
                ]))
            }
            attributedText.append(NSAttributedString(string: " • ", attributes: [
                .font: UIFont.regularFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlueTint1
            ]))
        } else {
            attributedText = NSMutableAttributedString()
        }
        var tags = [String]()
      
        if let priceBracket = recommendation.priceBracket, priceBracket > 0 {
            let price = String(repeating: "$", count: Int(priceBracket))
            tags.append(price)
        }
        if let category = recommendation.category {
            tags.append(category)
        }
        if let area = recommendation.area {
            tags.append(area)
        }
        attributedText.append(NSAttributedString(string: tags.joined(separator: " • "), attributes: [
            .font: UIFont.regularFontWithSize(size: 13),
            .foregroundColor: UIColor.themeDarkBlueTint1
        ]))
        return attributedText
    }
}
