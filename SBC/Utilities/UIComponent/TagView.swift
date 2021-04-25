import UIKit

class TagView: UIView {
    enum Style {
        case large, regular
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var style: Style = .regular {
        willSet {
            switch newValue {
            case .large:
                label.font = .mediumFontWithSize(size: 13)
            case .regular:
                label.font = .regularFontWithSize(size: 12)
            }
        }
    }

    private let label = UILabel()

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

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(
            width: originalSize.width,
            height: max(minHeight, originalSize.height)
        )
    }

    private func setupView() {
        style = .regular
        label.textColor = .themeDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.themeDarkBlueTint3.cgColor
    }

    private var minHeight: CGFloat {
        switch style {
        case .regular:
            return 24
        case .large:
            return 32
        }
    }
}
