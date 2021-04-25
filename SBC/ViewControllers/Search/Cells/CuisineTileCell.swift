import UIKit

class CuisineTileCell: UICollectionViewCell {

    @IBOutlet weak var cuisineImage: UIImageView!
    @IBOutlet weak var nearbyPinImage: UIImageView!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cuisineLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: "", fontSize: 16, textColor: .white, textAlignment: .center, numberOfLines: 0))
    }
    
    func configureWithCuisine(_ cuisine: Cuisine?) {
        if let cuisine = cuisine {
            nearbyPinImage.isHidden = true
            cuisineLabel.text = cuisine.name
            cuisineImage.downloaded(from: cuisine.imageUrl)
        } else {
            nearbyPinImage.isHidden = false
            cuisineLabel.text = "Explore nearby"
            cuisineImage.image = UIImage(named: "nearby_placeholder")
        }
    }

}
