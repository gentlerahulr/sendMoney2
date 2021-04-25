import UIKit

protocol ClearRecentSearchDelegate {
    func clearSearchAt(index: Int)
}

class RecentSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var searchLabel: UILabel!
    var index: Int = 0
    var delegate: ClearRecentSearchDelegate?
    
    func configureWithSearch(text: String, index: Int) {
        searchLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: text))
        self.index = index
    }

    @IBAction func removeSearch(_ sender: Any) {
        delegate?.clearSearchAt(index: index)
    }
    
}
