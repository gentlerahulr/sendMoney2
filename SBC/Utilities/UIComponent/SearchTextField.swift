import UIKit

@IBDesignable
class SearchTextField: UIControl {
    @IBInspectable
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }

    var tags: [String] {
        get {
            textField.tags
        }
        set {
            textField.tags = newValue
        }
    }

    var suggestedTags: [String] = [] {
        willSet {
            guard newValue != suggestedTags else {
                return
            }
            suggestedTagsView.tags = newValue
            if newValue.isEmpty {
                if mainStackView.arrangedSubviews.contains(tagsViewContainer) {
                    mainStackView.removeArrangedSubview(tagsViewContainer)
                    tagsViewContainer.removeFromSuperview()
                }
            } else {
                if !mainStackView.arrangedSubviews.contains(tagsViewContainer) {
                    mainStackView.addArrangedSubview(tagsViewContainer)
                }
            }
        }
    }

    @IBInspectable
    var placeholder: String? {
        get {
            textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }

    @IBInspectable
    var allowsEditing: Bool {
        get {
            textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }

    private let mainStackView = UIStackView()
    private let textField = TagTextField()
    private let suggestedTagsView = TagsView()
    private lazy var tagsViewContainer: UIView = {
        let container = UIView()
        suggestedTagsView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(suggestedTagsView)
        let label = UILabel()
        label.font = .boldFontWithSize(size: 13)
        label.textColor = .themeDarkBlue
        label.text = localizedStringForKey(key: "transactionlist.search.tags")
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: suggestedTagsView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: suggestedTagsView.trailingAnchor),
            container.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            container.trailingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor),
            container.topAnchor.constraint(equalTo: label.topAnchor),
            label.bottomAnchor.constraint(equalTo: suggestedTagsView.topAnchor, constant: -8),
            suggestedTagsView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupActions()
    }
}

extension SearchTextField {

    private func setupViews() {
        preservesSuperviewLayoutMargins = true
        backgroundColor = .themeWhite
        layoutMargins.top = 32
        layoutMargins.bottom = 24

        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        mainStackView.addArrangedSubview(textField)
    }

    private func setupActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouchUpInside)))
        textField.addTarget(self, action: #selector(onEditingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(onEditingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(onEditingDidEndOnExit), for: .editingDidEndOnExit)
        suggestedTagsView.onTagSelected = { [weak self] selectedTag in
            self?.tags.append(selectedTag)
            self?.sendActions(for: .editingChanged)
        }
    }
}

extension SearchTextField {
    @objc
    private func onTouchUpInside() {
        sendActions(for: .touchUpInside)
    }

    @objc
    private func onEditingDidBegin() {
        sendActions(for: .editingDidBegin)
    }

    @objc
    private func onEditingChanged() {
        sendActions(for: .editingChanged)
    }

    @objc
    private func onEditingDidEnd() {
        sendActions(for: .editingDidEnd)
    }

    @objc
    private func onEditingDidEndOnExit() {
        sendActions(for: .editingDidEndOnExit)
    }
}
