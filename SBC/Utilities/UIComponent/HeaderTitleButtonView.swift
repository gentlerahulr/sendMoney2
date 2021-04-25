//
//  HeaderTitleButtonView.swift
//  SBC
//

import UIKit

///This component includes a title and a button. Button is capable of two states and will report the current state when the button has been pressed. If this functionality is not needed just uses the same button title twice.

class HeaderTitleButtonView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: HeaderTitleButtonView.self)
    private let titleLabel = UILabel()
    private let button = UIButton()
    let lineView = UIView()
    var selectionEnabled = false
    
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
    
    var buttonNotSelectedStateTitle: String? {
        didSet {
            updateButtonTitle()
            button.layoutIfNeeded()
        }
    }
    
    var buttonSelectedStateTitle: String? {
        didSet {
            updateButtonTitle()
            button.layoutIfNeeded()
        }
    }
    
    var buttonAction: (() -> Void)?
    
    private func updateButtonTitle() {
        let title = selectionEnabled ? buttonSelectedStateTitle : buttonNotSelectedStateTitle
        button.setTitle(title, for: .normal)
    }
    
    @objc
    func buttonTapped() {
        selectionEnabled.toggle()
        updateButtonTitle()
        buttonAction?()
    }

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
    
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        button.setTitleColor(.themeDarkBlue, for: .normal)
        button.titleLabel?.setLabelConfig(
            lblConfig: .getMediumLabelConfig(
                text: title,
                fontSize: 13,
                textColor: .themeDarkBlue
            )
        )
        
        let layoutHelperStack = UIStackView(arrangedSubviews: [titleLabel, button])
        layoutHelperStack.axis = .horizontal
        layoutHelperStack.distribution = .fill
        layoutHelperStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(layoutHelperStack)
        NSLayoutConstraint.activate([
            layoutHelperStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            layoutHelperStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
            layoutHelperStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.topAnchor),
            layoutHelperStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .themeNeonBlue
        contentView.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -4),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        contentView.backgroundColor = .themeWhite
    }
}
