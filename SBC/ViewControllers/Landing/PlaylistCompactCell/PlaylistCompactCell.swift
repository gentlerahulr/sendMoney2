//
//  PlaylistCompactCell.swift
//  SBC
//

import UIKit

class PlaylistCompactCell: UICollectionViewCell {
    
    @IBOutlet weak var dealsView: UIView!
    @IBOutlet private weak var dealsLabel: UILabel!
    @IBOutlet weak var playlistImageView: DoubleImageView!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var placeCounterLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    private var playlist: Playlist?
    private var recommendation: Recommendation?
    var likePlaylistAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        dealsView.backgroundColor = .themeNeonGreen
        dealsLabel.setLabelConfig(lblConfig: LabelConfig.getMediumLabelConfig(text: "venue_deals".localized(bundle: Bundle.main), fontSize: 13))
        playlistImageView.layer.cornerRadius = 8.0
        placeCounterLabel.font = UIFont.mediumFontWithSize(size: 12)
        placeCounterLabel.textColor = UIColor.themeWhite
        playlistTitleLabel.font = UIFont.boldFontWithSize(size: 16)
        playlistTitleLabel.textColor = UIColor.themeDarkBlue
        creatorNameLabel.font = UIFont.regularFontWithSize(size: 12)
        creatorNameLabel.textColor = UIColor.themeDarkBlueTint1
        playlistImageView.image = UIImage(named: "playlistPlaceholder")
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        let toAdd = likeButton.isSelected ? 1 : -1
        if let playlist = playlist {
            let newLikeCount = "\(playlist.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        } else if let recommendation = recommendation {
            let newLikeCount = "\(recommendation.likeCount + toAdd)"
            likeButton.setTitle(newLikeCount, for: .normal)
        }
        likePlaylistAction?()
    }
    
    func configureWithPlaylist(playlist: Playlist) {
        dealsView.isHidden = !(playlist.hasDeals ?? true)
        
        likeButton.setTitle("\(playlist.likeCount)", for: .normal)
        likeButton.isSelected = playlist.isLiked
        loadImageForDoubleImageView(urlString: playlist.imageUrl)
        let venuesCount = playlist.placeCount
        placeCounterLabel.text = venuesCount == 1 ? "\(venuesCount) " + "playlist_label_place".localized(bundle: Bundle.main) : "\(venuesCount) " + "playlist_label_places".localized(bundle: Bundle.main)
        playlistTitleLabel.text = playlist.title
        if let creator = playlist.creator {
            var username = creator.username
            if creator.id == KeyChainServiceWrapper.standard.userHashId {
                username = "me"
            }
            creatorNameLabel.text = "By " + (username ?? "")
            if let creatorPicture = creator.profilePictureUrl {
                creatorImageView.image = UIImage(named: creatorPicture)
            } else {
                creatorImageView.image = nil
            }
        } else {
            creatorNameLabel.text = "By ONZ"
            creatorImageView.image = UIImage(named: "onzAppIcon")
        }
        self.playlist = playlist
    }
    
    func configureWithRecommendation(recommendation: Recommendation) {
        dealsView.isHidden = !recommendation.hasDeals
        likeButton.setTitle("\(recommendation.likeCount)", for: .normal)
        likeButton.isSelected = recommendation.isLiked
        loadImageForDoubleImageView(urlString: recommendation.imageURL)
        let placesCount = recommendation.placeCount ?? 0
        placeCounterLabel.text = placesCount == 1 ? "\(placesCount) " + "playlist_label_place".localized(bundle: Bundle.main) : "\(placesCount) " + "playlist_label_places".localized(bundle: Bundle.main)
        playlistTitleLabel.text = recommendation.title
        if let creator = recommendation.creator {
            var username = creator.username
            
            if creator.id == KeyChainServiceWrapper.standard.userHashId {
                username = "me"
            }
            
            creatorNameLabel.text = "By " + (username ?? "")
            
            if let profilePictureUrl = creator.profilePictureUrl {
                creatorImageView.downloaded(from: profilePictureUrl)
            } else {
                creatorImageView.image = nil
            }
        } else {
            creatorNameLabel.text = "By ONZ"
            creatorImageView.image = UIImage(named: "onzAppIcon")
        }
        self.recommendation = recommendation
    }
    
    private func loadImageForDoubleImageView(urlString: String?) {
        if let imageUrlString = urlString, imageUrlString.isValidURL(),
           let imageUrl = URL(string: imageUrlString) {
            loadImage(url: imageUrl)
        } else {
            playlistImageView.image = UIImage(named: "playlistPlaceholder")
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
            DispatchQueue.main.async { [weak self] in
                if url == response?.url {
                    self?.playlistImageView.image = image
                }
            }
        }.resume()
    }
    
}
