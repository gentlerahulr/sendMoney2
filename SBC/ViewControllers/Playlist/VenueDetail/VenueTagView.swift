import UIKit

class VenueTagView: UIView {
    var tagLabel = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.themeDarkBlueTint3.cgColor
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tagLabel)
        tagLabel.setLabelConfig(
            lblConfig: .getRegularLabelConfig(
                text: "",
                fontSize: 13
            ))
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
