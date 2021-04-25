import UIKit

class TagTextField: UIControl, UITextInputTraits {
    var tags: [String] = [] {
        didSet {
            updateText()
            updateTags()
            updateClearButton()
        }
    }

    var text: String? {
        didSet {
            updateText()
            updateClearButton()
        }
    }
    var placeholder: String? {
        didSet {
            updateText()
        }
    }

    @objc var returnKeyType: UIReturnKeyType = .search

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let internalLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumFontWithSize(size: 16)
        label.numberOfLines = 1
        return label
    }()
    private let clearButton: UIView = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "clearBtn"), for: .normal)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()
    private let textSrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        setupViews()
        updateText()
        updateTags()
        updateClearButton()
    }
}

extension TagTextField {
    private func setupViews() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
        layer.backgroundColor = UIColor.themeDarkBlueTint3.cgColor
        layer.cornerRadius = 6

        guard mainStackView.superview == nil else {
            return
        }
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 8
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -8),
            trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 8),
            topAnchor.constraint(equalTo: mainStackView.topAnchor),
            bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])

        let imageView = UIImageView(image: UIImage(named: "core_icon-search"))
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        mainStackView.addArrangedSubview(imageView)
        textSrollView.addSubview(textStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textSrollView.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            textSrollView.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor),
            textSrollView.topAnchor.constraint(equalTo: textStackView.topAnchor),
            textSrollView.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor),
            textSrollView.heightAnchor.constraint(equalTo: textStackView.heightAnchor)
        ])
        mainStackView.addArrangedSubview(textSrollView)
        textStackView.addArrangedSubview(internalLabel)
    }

    private func updateText() {
        guard hasText else {
            internalLabel.text = placeholder
            internalLabel.textColor = .themeDarkBlueTint1
            return
        }
        internalLabel.text = text
        internalLabel.textColor = .themeDarkBlue
    }

    private func updateTags() {
        for tagView in textStackView.arrangedSubviews.filter({ $0 is InputTagView }) {
            textStackView.removeArrangedSubview(tagView)
            tagView.removeFromSuperview()
        }
        for tag in tags where !textStackView.arrangedSubviews.isEmpty {
            let tagView = InputTagView()
            tagView.text = tag
            tagView.isUserInteractionEnabled = true
            tagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeTag)))
            textStackView.insertArrangedSubview(tagView, at: textStackView.arrangedSubviews.count - 1)
        }
    }

    private func updateClearButton() {
        if hasText && clearButton.superview == nil {
            mainStackView.addArrangedSubview(clearButton)
        }
        if !hasText && clearButton.superview != nil {
            mainStackView.removeArrangedSubview(clearButton)
            clearButton.removeFromSuperview()
        }
    }

    @objc
    private func clearText() {
        text = nil
        tags = []
        sendActions(for: .editingChanged)
    }

    @objc
    private func removeTag(_ recog: UITapGestureRecognizer) {
        guard let tagView = recog.view as? InputTagView else {
            return
        }
        if let index = tags.lastIndex(of: tagView.text ?? "") {
            tags.remove(at: index)
            sendActions(for: .editingChanged)
        }
    }
}

extension TagTextField {
    override var canBecomeFirstResponder: Bool {
        isEnabled
    }

    override var canBecomeFocused: Bool {
        true
    }

    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            sendActions(for: .editingDidBegin)
            return true
        } else {
            return false
        }
    }

    override func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            sendActions(for: .editingDidEnd)
            return true
        } else {
            return false
        }
    }

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width, height: max(originalSize.height, 48))
    }
}

extension TagTextField: UIKeyInput {
    var hasText: Bool {
        !tags.isEmpty || !(text ?? "").isEmpty
    }

    func insertText(_ text: String) {
        self.text = self.text ?? ""
        if text == "\n" {
            _ = resignFirstResponder()
            sendActions(for: .editingDidEndOnExit)
        } else {
            self.text?.append(text)
            sendActions(for: .editingChanged)
            textSrollView.setContentOffset(
                CGPoint(x: max(textSrollView.contentSize.width - textSrollView.frame.width, 0), y: 0),
                animated: false
            )
        }
    }

    func deleteBackward() {
        if !(text ?? "").isEmpty {
            text?.removeLast()
            sendActions(for: .editingChanged)
        } else if !tags.isEmpty {
            tags.removeLast()
            sendActions(for: .editingChanged)
        }
    }
}

// MARK: InputTagView

private class InputTagView: UILabel {
    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    override func layoutSubviews() {
        setupStyle()
        super.layoutSubviews()
    }

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(
            width: originalSize.width + 16,
            height: max(24, originalSize.height + 8)
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    private func setupStyle() {
        textAlignment = .center
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 4
        font = .regularFontWithSize(size: 12)
        textColor = .themeDarkBlue
        numberOfLines = 1
    }
}

extension UIView {
    fileprivate func drawToImage() -> UIImage {
        sizeToFit()
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    fileprivate func withEdgeInsets(_ insets: UIEdgeInsets) -> UIImage {
        let imageSize = CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(at: CGPoint(x: insets.left, y: insets.top))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
