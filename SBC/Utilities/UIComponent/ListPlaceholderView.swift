import UIKit

class ListPlaceholderView: UIView {
    struct Config {
        let title: String
        let message: String
        let image: UIImage?
    }

    private let labelTitle = UILabel()
    private let labelMessage = UILabel()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
}

extension ListPlaceholderView {
    func setUp(with config: Config) {
        labelTitle.text = config.title
        labelMessage.text = config.message
        imageView.image = config.image
    }
}

extension ListPlaceholderView {
    private func setupSubviews() {
        let container = createMainContainer()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        preservesSuperviewLayoutMargins = true
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            container.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func createMainContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.font = .boldFontWithSize(size: 22)
        labelTitle.textColor = .themeDarkBlue
        labelMessage.numberOfLines = 0
        labelMessage.textAlignment = .center
        labelMessage.font = .regularFontWithSize(size: 16)
        labelMessage.textColor = .themeDarkBlue

        [labelTitle, labelMessage, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }

        // Horizontal
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            labelMessage.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            labelMessage.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        // Vertical
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            labelTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            labelMessage.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            labelMessage.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
}
