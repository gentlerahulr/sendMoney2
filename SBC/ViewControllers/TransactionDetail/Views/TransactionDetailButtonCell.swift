import UIKit

class TransactionDetailButtonCell: UIView {
    var title: String? {
        willSet {
            labelTitle.text = newValue
        }
    }

    var actionTitle: String? {
        willSet {
            buttonAction.underlineButton(text: newValue ?? "")
        }
    }

    var onActionClickedHandler: (() -> Void)?

    var detailView: UIView? {
        didSet {
            if let oldValue = oldValue {
                mainStack.removeArrangedSubview(oldValue)
                oldValue.removeFromSuperview()
            }
            if let newValue = detailView {
                mainStack.addArrangedSubview(newValue)
            }
        }
    }

    private let mainStack = UIStackView()
    private let labelTitle = UILabel()
    private let buttonAction = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
}

// MARK: - Event handler

extension TransactionDetailButtonCell {
    @objc private func onButtonTapped() {
        onActionClickedHandler?()
    }
}

// MARK: - Private methods

extension TransactionDetailButtonCell {
    private func setupSubviews() {
        layoutMargins.top = 16
        layoutMargins.bottom = 16
        layoutMargins.left = 16
        layoutMargins.right = 16

        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        NSLayoutConstraint.activate([
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            layoutMarginsGuide.topAnchor.constraint(equalTo: mainStack.topAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
        ])

        let container = UIView()
        labelTitle.font = .mediumFontWithSize(size: 16)
        labelTitle.textColor = .themeDarkBlue
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(labelTitle)
        buttonAction.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        buttonAction.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(buttonAction)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            container.topAnchor.constraint(equalTo: labelTitle.topAnchor),
            container.bottomAnchor.constraint(equalTo: labelTitle.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: buttonAction.trailingAnchor),
            container.topAnchor.constraint(equalTo: buttonAction.topAnchor),
            container.bottomAnchor.constraint(equalTo: buttonAction.bottomAnchor),
            buttonAction.leadingAnchor.constraint(greaterThanOrEqualTo: labelTitle.trailingAnchor)
        ])
        mainStack.addArrangedSubview(container)
    }
}
