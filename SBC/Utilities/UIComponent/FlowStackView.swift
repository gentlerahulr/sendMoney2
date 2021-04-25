import UIKit

class FlowStackView: UIView {
    var arrangedSubviews: [UIView] {
        get { _arrangedSubviews }
        set { _arrangedSubviews = newValue }
    }

    var spacing: CGFloat = 8.0 {
        didSet {
            _internalStackView.spacing = spacing
            arrangeSubviews(_arrangedSubviews)
        }
    }

    var numberOfLines: Int {
        _containerStackViews.count
    }

    var maxNumberOfLines: Int = 0 {
        didSet {
            if oldValue != maxNumberOfLines {
                arrangeSubviews(arrangedSubviews)
            }
        }
    }

    private var _arrangedSubviews: [UIView] = [] {
        willSet {
            arrangeSubviews(newValue)
        }
    }

    private var previousSize: CGSize? {
        willSet {
            if newValue != previousSize {
                arrangeSubviews(arrangedSubviews)
            }
        }
    }

    private let _internalStackView = UIStackView()

    private var _containerStackViews: [UIView] = []

    override func layoutSubviews() {
        if _internalStackView.superview == nil {
            _internalStackView.axis = .vertical
            _internalStackView.spacing = spacing
            _internalStackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(_internalStackView)
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: _internalStackView.topAnchor),
                bottomAnchor.constraint(equalTo: _internalStackView.bottomAnchor),
                leadingAnchor.constraint(equalTo: _internalStackView.leadingAnchor),
                trailingAnchor.constraint(equalTo: _internalStackView.trailingAnchor)
            ])
        }
        super.layoutSubviews()
        previousSize = frame.size
    }
}

// MARK: - Private methods

extension FlowStackView {
    private func arrangeSubviews(_ subviews: [UIView]) {
        _internalStackView.arrangedSubviews.forEach {
            _internalStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        _containerStackViews = subviews.groupedByWidth(frame.width, spacing: spacing).map { views in
            views.containerStackView(spacing: spacing)
        }

        let allStacks: [UIView]
        if maxNumberOfLines > 0 {
            allStacks = Array(_containerStackViews.prefix(maxNumberOfLines))
        } else {
            allStacks = _containerStackViews
        }
        allStacks.forEach { _internalStackView.addArrangedSubview($0) }
    }
}

extension Array where Element == UIView {
    fileprivate func groupedByWidth(_ width: CGFloat, spacing: CGFloat) -> [[UIView]] {
        reduce(into: [[UIView]]()) { result, view in
            if result.isEmpty {
                result.append([view])
            } else {
                let lastIndex = result.endIndex.advanced(by: -1)
                if result[lastIndex].isEmpty {
                    result[lastIndex].append(view)
                } else {
                    let viewWidth = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
                    let stackWidth = result[lastIndex].map {
                        $0.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width + spacing
                    }.reduce(0, +)
                    if (viewWidth + stackWidth) > width {
                        result.append([view])
                    } else {
                        result[lastIndex].append(view)
                    }
                }
            }
        }
    }

    fileprivate func containerStackView(spacing: CGFloat) -> UIView {
        let container = UIView()
        forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }

        for index in 0 ..< count {
            let currentView = self[index]
            NSLayoutConstraint.activate([
                currentView.topAnchor.constraint(equalTo: container.topAnchor),
                currentView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
            if index == 0 {
                currentView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            } else {
                currentView.leadingAnchor.constraint(
                    equalTo: self[index - 1].trailingAnchor,
                    constant: spacing
                ).isActive = true
            }
        }
        return container
    }
}
