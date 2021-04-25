import UIKit
import SDWebImage

extension UIImageView {
    func downloaded(from url: URL?, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeholder: UIImage? = nil) {
        contentMode = mode
        sd_setImage(with: url, placeholderImage: placeholder)
    }
    
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeholder: UIImage? = nil) {
        guard let urlString = link, let url = URL(string: urlString) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
