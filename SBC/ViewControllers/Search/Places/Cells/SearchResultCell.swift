//
//  SearchResultCell.swift
//  SBC
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var infosLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeNameLabel.font = .mediumFontWithSize(size: 16)
        placeNameLabel.textColor = .themeDarkBlue
        
        infosLabel.font = .regularFontWithSize(size: 12)
        infosLabel.textColor = .themeDarkBlueTint1
    }

    func configureWithSearchResult(_ searchResult: SearchResult) {
        placeNameLabel.text = searchResult.name
        placeImageView.contentMode = .scaleAspectFit
        if searchResult.type == "venue" {
            infosLabel.attributedText = createTagsLabel(searchResult: searchResult)
            placeImageView.downloaded(from: searchResult.imageURL)
            likesLabel.isHidden = true
            infosLabel.isHidden = false
        } else if searchResult.type == "playlist" {
            placeImageView.downloaded(from: searchResult.imageURL)
            if let placeCount = searchResult.placeCount {
                let place = placeCount <= 1 ? "place" : "places"
                infosLabel.text = "\(placeCount) \(place)"
                infosLabel.isHidden = false
            }
            if let likeCount = searchResult.likeCount {
                likesLabel.attributedText = createLikesLabel(likesCount: likeCount)
                likesLabel.isHidden = false
            }
        } else if searchResult.type == "cuisine" {
            likesLabel.isHidden = true
            infosLabel.isHidden = true
            placeImageView.image = UIImage(named: "coreIconDining")
            placeImageView.backgroundColor = .themeDarkBlueTint3
            placeImageView.contentMode = .center
        }
    }
    
    private func createTagsLabel(searchResult: SearchResult) -> NSAttributedString {
        let attributedText: NSMutableAttributedString
        if let rating = searchResult.rating, rating > 0.0 {
            let ratingImage = NSTextAttachment()
            ratingImage.image = UIImage(named: "coreIconRateFill")
            let imageOffsetY: CGFloat = -3.5
            ratingImage.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
            attributedText = NSMutableAttributedString(attachment: ratingImage)
            attributedText.append(NSAttributedString(string: String(rating), attributes: [
                .font: UIFont.boldFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlue
            ]))
            attributedText.append(NSAttributedString(string: " • ", attributes: [
                .font: UIFont.regularFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlueTint1
            ]))
        } else {
            attributedText = NSMutableAttributedString()
        }
        var tags = [String]()
      
        if let priceBracket = searchResult.priceBracket, priceBracket > 0 {
            let price = String(repeating: "$", count: Int(priceBracket))
            tags.append(price)
        }
        if let cuisines = searchResult.cuisines, cuisines.count > 0 {
            let names = cuisines.compactMap{ $0.name }
            let allNames = names.joined(separator: ", ")
            tags.append(allNames)
        }
        if let area = searchResult.area {
            tags.append(area)
        }
        attributedText.append(NSAttributedString(string: tags.joined(separator: " • "), attributes: [
            .font: UIFont.regularFontWithSize(size: 13),
            .foregroundColor: UIColor.themeDarkBlueTint1
        ]))
        return attributedText
    }
    
    private func createLikesLabel(likesCount: Int) -> NSAttributedString {
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: String(likesCount), attributes: [
            .font: UIFont.boldFontWithSize(size: 13),
            .foregroundColor: UIColor.themeDarkBlue
        ]))
        
        let like = likesCount <= 1 ? " like" : " likes"
        attributedText.append(NSAttributedString(string: like, attributes: [
            .font: UIFont.regularFontWithSize(size: 12),
            .foregroundColor: UIColor.themeDarkBlueTint1
        ]))
        return attributedText
    }
}
