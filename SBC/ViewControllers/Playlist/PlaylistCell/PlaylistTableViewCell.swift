import UIKit

class PlaylistTableViewCell: UITableViewCell {
    @IBOutlet private weak var playlistImageView: UIImageView!
    @IBOutlet private weak var playlistNameLabel: UILabel!
    @IBOutlet private weak var playlistCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        playlistNameLabel.setLabelConfig(lblConfig: LabelConfig.getMediumLabelConfig(text: ""))
        playlistCountLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: "", fontSize: 12, textColor: UIColor.themeDarkBlueTint1))
    }
    
    func configureWithPlaylist(playlist: Playlist, venue: Venue) {
        playlistNameLabel.text = playlist.title
        if playlist.hasRequestedVenue ?? false {
            playlistCountLabel.text = localizedStringForKey(key: "addTo_list_adreadyAdded")
            self.contentView.alpha = 0.80
            isUserInteractionEnabled = false
        } else {
            let place = playlist.placeCount <= 1 ? "place" : "places"
            playlistCountLabel.text = "\(playlist.placeCount) \(place)"
            self.contentView.alpha = 1
            isUserInteractionEnabled = true
        }
        
        if let imageUrl = playlist.imageUrl {
            playlistImageView.downloaded(from: imageUrl)
        }
        
    }
    
}
