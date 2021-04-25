import UIKit

extension UIViewController {
    func copied(content: String) {
        UIPasteboard.general.string = content
    }
}
