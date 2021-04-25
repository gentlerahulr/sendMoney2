//
//  PlaylistTileCell.swift
//  SBC
//

import UIKit

class PlaylistTileCell: UITableViewCell {
    
    @IBOutlet weak var doubleImageView: DoubleImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var placeCounterLabel: UILabel!
    @IBOutlet weak var dealsView: UIView!
    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var likePlaylistAction: (() -> Void)?
    private var playlist: Playlist?
    private var recommendation: Recommendation?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        dealsView.backgroundColor = .themeNeonGreen
        dealsLabel.setLabelConfig(lblConfig: LabelConfig.getMediumLabelConfig(text: "venue_deals".localized(bundle: Bundle.main), fontSize: 13))
        
        doubleImageView.layer.cornerRadius = 8.0
        placeCounterLabel.font = UIFont.mediumFontWithSize(size: 12)
        placeCounterLabel.textColor = UIColor.themeWhite
        titleLabel.font = UIFont.boldFontWithSize(size: 16)
        titleLabel.textColor = UIColor.themeDarkBlue
        profileNameLabel.font = UIFont.regularFontWithSize(size: 12)
        profileNameLabel.textColor = UIColor.themeDarkBlueTint1
        //doubleImageView.image = UIImage(named: "playlistPlaceholder")
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        likeButton.isSelected = !likeButton.isSelected
        let toAdd = likeButton.isSelected ? 1 : -1
        
        if let playlist = playlist {
            let newLikeCount = "\(playlist.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        } else if let recommedation = recommendation {
            let newLikeCount = "\(recommedation.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        }
        likePlaylistAction?()
    }
    
    func configureWithPlaylist(playlist: Playlist, forLike: Bool = false) {
        dealsView.isHidden = !(playlist.hasDeals ?? true)
        let venuesCount = playlist.placeCount
        placeCounterLabel.text = venuesCount > 1 ? "\(venuesCount) " + "playlist_label_places".localized(bundle: Bundle.main) : "\(venuesCount) " + "playlist_label_place".localized(bundle: Bundle.main)

        likeButton.setTitle("\(playlist.likeCount)", for: .normal)
        likeButton.isSelected = playlist.isLiked
        loadImageForDoubleImageView(urlString: playlist.imageUrl)
        
        titleLabel.text = playlist.title
        
        if let creator = playlist.creator {
            var username = creator.username
            
            if creator.id == KeyChainServiceWrapper.standard.userHashId {
                username = "me"
            }
            
            profileNameLabel.text = "By " + (username ?? "")
            
            if let profilePictureUrl = creator.profilePictureUrl {
                profileImageView.downloaded(from: profilePictureUrl)
            } else {
                profileImageView.image = nil
            }
        } else {
            profileNameLabel.text = "By ONZ"
            profileImageView.image = UIImage(named: "onzAppIcon") 
        }
        self.playlist = playlist
        bottomConstraint.constant = forLike ? 28 : 0
    }
    
    func configureWithRecommendation(recommendation: Recommendation) {
        dealsView.isHidden = !recommendation.hasDeals
        likeButton.setTitle("\(recommendation.likeCount)", for: .normal)
        likeButton.isSelected = recommendation.isLiked
        loadImageForDoubleImageView(urlString: recommendation.imageURL)
        let placesCount = recommendation.placeCount ?? 0
            placeCounterLabel.text = placesCount == 1 ? "\(placesCount) " + "playlist_label_place".localized(bundle: Bundle.main) : "\(placesCount) " + "playlist_label_places".localized(bundle: Bundle.main)
        titleLabel.text = recommendation.title
        if let creator = recommendation.creator {
            var username = creator.username
            
            if creator.id == KeyChainServiceWrapper.standard.userHashId {
                username = "me"
            }
            
            profileNameLabel.text = "By " + (username ?? "")
            
            if let profilePictureUrl = creator.profilePictureUrl {
                profileImageView.downloaded(from: profilePictureUrl)
            } else {
                profileImageView.image = nil
            }
        } else {
            profileNameLabel.text = "By ONZ"
            profileImageView.image = UIImage(named: "onzAppIcon")
        }
        self.recommendation = recommendation
    }
    
    private func loadImageForDoubleImageView(urlString: String?) {
        if let imageUrlString = urlString, imageUrlString.isValidURL(),
           let imageUrl = URL(string: imageUrlString) {
            loadImage(url: imageUrl)
        } else {
            doubleImageView.image = UIImage(named: "playlistPlaceholder")
        }
    }
    
    private func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {[weak self] in
                if url == response?.url {
                    self?.doubleImageView.image = image
                }
            }
        }.resume()
    }
    
}
