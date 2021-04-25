//
//  YouLikedHeaderView.swift
//  SBC
//
//
import UIKit

class HeaderTitleView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: HeaderTitleView.self)

    var title: String? {
        willSet {
            titleLabel.setLabelConfig(
                lblConfig: .getBoldLabelConfig(
                    text: newValue,
                    fontSize: 20,
                    textColor: .themeDarkBlue
                )
            )
        }
    }
    
    private let titleLabel = UILabel()

    convenience init() {
        self.init(frame: .zero)
        setupView()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        let layoutHelperStack = UIStackView(arrangedSubviews: [titleLabel])
        layoutHelperStack.axis = .horizontal
        layoutHelperStack.distribution = .fill
        layoutHelperStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(layoutHelperStack)
        NSLayoutConstraint.activate([
            layoutHelperStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            layoutHelperStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            layoutHelperStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.topAnchor),
            layoutHelperStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
        contentView.backgroundColor = UIColor.themeWhite
    }
}
