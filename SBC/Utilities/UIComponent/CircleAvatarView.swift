import UIKit

@IBDesignable
class CircleAvatarView: UIView {
    enum Image {
        case credit
    }

    @IBInspectable
    var title: String? {
        willSet {
            labelInitial.text = newValue?.initial
        }
    }

    @IBInspectable
    var textSize: CGFloat = initialFontSize {
        willSet {
            labelInitial.font = .mediumFontWithSize(size: newValue)
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        willSet {
            layer.borderWidth = newValue
        }
    }

    var image: Image? {
        willSet {
            imageIcon.image = {
                switch newValue {
                case .some(.credit):
                    return UIImage(named: "icon-topup")
                case .none:
                    return nil
                }
            }()
        }
    }

    private let labelInitial = UILabel()
    private let imageIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

// MARK: - UIView overrides

extension CircleAvatarView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
        layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
    }
}

// MARK: - Private methods

extension CircleAvatarView {
    private func setupViews() {
        [labelInitial, imageIcon].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        labelInitial.font = .mediumFontWithSize(size: initialFontSize)
        labelInitial.textAlignment = .center
        labelInitial.textColor = .themeDarkBlue
        labelInitial.backgroundColor = .themeNeonYellowTint2
        imageIcon.contentMode = .scaleAspectFill
        backgroundColor = .clear
    }
}

private let initialFontSize: CGFloat = 16
