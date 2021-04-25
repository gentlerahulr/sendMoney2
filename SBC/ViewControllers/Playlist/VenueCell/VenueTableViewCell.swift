import UIKit

class VenueTableViewCell: UITableViewCell {
    @IBOutlet private weak var dealsView: UIView!
    @IBOutlet private weak var dealsLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet private weak var venueTitleLabel: UILabel!
    @IBOutlet private weak var venueInfosLabel: UILabel!
    @IBOutlet private weak var venueCaptionLabel: UILabel!
    @IBOutlet private weak var creatorImageView: UIImageView!
    @IBOutlet private weak var readMoreButton: UIButton!
    @IBOutlet private weak var captionView: UIStackView!
    @IBOutlet private weak var gradientView: UIView!
    
    var readMoreAction: (() -> Void)?
    var addVenueAction: (() -> Void)?
    var likeVenueAction: (() -> Void)?
    
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
        venueCaptionLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: "", numberOfLines: 3))
        readMoreButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: "venue_read_more".localized(bundle: Bundle.main)))
        readMoreButton.titleLabel?.numberOfLines = 0
        readMoreButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        readMoreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        readMoreButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        let attributedString = NSMutableAttributedString(string: "venue_read_more".localized(bundle: Bundle.main), attributes: [NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.underlineColor: UIColor.themeNeonBlue])
        readMoreButton.setAttributedTitle(attributedString, for: .normal)
        let attributedStringSelected = NSMutableAttributedString(string: "venue_read_less".localized(bundle: Bundle.main), attributes: [NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.underlineColor: UIColor.themeNeonBlue])
        readMoreButton.setAttributedTitle(attributedStringSelected, for: .selected)
    }
    
    func configureWithVenue(venue: Venue) {
        dealsView.isHidden = !(venue.hasDeals ?? false)
        likeButton.setTitle("\(venue.likeCount)", for: .normal)
        likeButton.isSelected = venue.isLiked
        if let imageUrl = venue.imageUrl {
            venueImageView.downloaded(from: imageUrl)
        } else {
            venueImageView.image = nil
        }
        
        venueTitleLabel.text = venue.name
        venueInfosLabel.text = createTagsString(venue: venue)
        
        if let caption = venue.caption, !caption.isEmpty {
            captionView.isHidden = false
            venueCaptionLabel.text = venue.caption
            venueCaptionLabel.frame = CGRect(x: venueCaptionLabel.frame.origin.x, y: venueCaptionLabel.frame.origin.y, width: captionView.frame.width - creatorImageView.frame.width, height: 0)
            readMoreButton.isHidden = venueCaptionLabel.calculateMaxLines() <= 3
        } else {
            captionView.isHidden = true
        }
    }
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        addVenueAction?()
    }
    
    @IBAction private func readMoreButtonTapped(_ sender: Any) {
        readMoreButton.isSelected = !readMoreButton.isSelected
        venueCaptionLabel.numberOfLines = readMoreButton.isSelected ? 0 : 3
        readMoreAction?()
    }
    
    @IBAction private func likeTapped(_ sender: Any) {
        likeVenueAction?()
    }
    
    private func createTagsString(venue: Venue) -> String {
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
        return tags.joined(separator: " • ")
    }
}
