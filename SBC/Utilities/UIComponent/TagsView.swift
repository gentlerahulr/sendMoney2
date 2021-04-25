import UIKit

class TagsView: UIView {
    var tags: [String] = [] {
        didSet {
            if oldValue != tags {
                isExpanded = false
                updateTags()
            }
        }
    }
    var style: TagView.Style = .regular {
        didSet {
            if oldValue != style {
                updateTags()
            }
        }
    }
    var onTagSelected: ((String) -> Void)?
    private(set) var isExpanded: Bool = false

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private let mainStackView = UIStackView()
    private let flowStackView = FlowStackView()
    private lazy var viewMoreButtonContainer: UIView = {
        let button = UIButton(type: .system)
        button.underlineButton(
            text: localizedStringForKey(key: "transactionlist.search.tags.viewmore")
        )
        button.addTarget(self, action: #selector(onTapViewMore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.addSubview(button)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            container.topAnchor.constraint(equalTo: button.topAnchor),
            container.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            container.trailingAnchor.constraint(greaterThanOrEqualTo: button.trailingAnchor)
        ])
        return container
    }()
}

extension TagsView {
    private func setup() {
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(flowStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            topAnchor.constraint(equalTo: mainStackView.topAnchor),
            bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    private func updateTags() {
        flowStackView.maxNumberOfLines = isExpanded ? 0 : 1
        flowStackView.arrangedSubviews = tags.map {
            let view = TagView()
            view.text = $0
            view.style = self.style
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapTagView)))
            return view
        }

        // Has multiple lines and the tags are not expanded yet
        if !isExpanded && flowStackView.numberOfLines > 1 {
            if !mainStackView.arrangedSubviews.contains(viewMoreButtonContainer) {
                mainStackView.addArrangedSubview(viewMoreButtonContainer)
            }
        } else {
            if mainStackView.arrangedSubviews.contains(viewMoreButtonContainer) {
                mainStackView.removeArrangedSubview(viewMoreButtonContainer)
                viewMoreButtonContainer.removeFromSuperview()
            }
        }
    }

    @objc private func onTapTagView(_ recog: UITapGestureRecognizer) {
        guard let tagView = recog.view as? TagView, let text = tagView.text else {
            return
        }
        onTagSelected?(text)
    }

    @objc private func onTapViewMore() {
        isExpanded = true
        updateTags()
    }
}
