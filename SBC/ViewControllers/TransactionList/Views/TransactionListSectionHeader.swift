import UIKit

class TransactionListSectionHeader: UITableViewHeaderFooterView {

    var date: Date? {
        willSet {
            dateLabel.setLabelConfig(
                lblConfig: .getBoldLabelConfig(
                    text: String.fromDate(
                        newValue ?? Date(),
                        dateFormat: .ddMMMMyyyyE,
                        doesRelativeFormatting: true
                    ),
                    fontSize: 12,
                    textColor: .themeLightBlue
                )
            )
        }
    }
    var amount: Double? {
        willSet {
            amountLabel.setLabelConfig(
                lblConfig: .getBoldLabelConfig(
                    text: String.formatCurrency(from: newValue ?? 0.0),
                    fontSize: 12,
                    textColor: .themeLightBlue,
                    textAlignment: .natural
                )
            )
        }
    }

    private let dateLabel = UILabel()
    private let amountLabel = UILabel()

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
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [dateLabel, amountLabel])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        contentView.backgroundColor = .white

        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .themeDarkBlueTint2
        contentView.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
