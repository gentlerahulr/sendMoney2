import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagView: VenueTagView!
    
    func config(info: String) {
        tagView.tagLabel.text = info
        tagView.isHidden = info == ""
    }
}
