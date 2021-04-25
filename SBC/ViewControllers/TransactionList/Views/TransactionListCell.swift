import UIKit

class TransactionListCell: UITableViewCell {
    struct Config {
        let transactionDescription: String?
        let amount: Double
        let currencyISO: String
        let tags: [String]
        let notes: String?
    }

    @IBOutlet private var circleContainer: UIView?
    @IBOutlet private var mainStack: UIStackView?

    @IBOutlet private var circleAvatar: CircleAvatarView?
    @IBOutlet private var transactionDescriptionLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var tagsStack: UIStackView?
    @IBOutlet private var noteLabel: UILabel?
}

extension TransactionListCell {
    func setCellConfig(_ config: Config) {
        transactionDescriptionLabel?.text = config.transactionDescription
        amountLabel?.text = .formatCurrency(from: config.amount, currency: config.currencyISO)
        noteLabel?.text = config.notes?.trim()

        circleAvatar?.title = config.transactionDescription
        if config.amount > 0 {
            circleAvatar?.image = .credit
            updateTags([localizedStringForKey(key: "transactionlist.tag.topup")])
        } else {
            circleAvatar?.image = nil
            updateTags(config.tags)
        }
    }
}

// MARK: - Helpers

extension TransactionListCell {
    private func updateTags(_ tags: [String]) {
        guard let tagsStack = tagsStack else {
            return
        }
        tagsStack.arrangedSubviews.forEach {
            tagsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        tags.prefix(2).forEach {
            let tagView = TagView()
            tagView.text = $0
            tagsStack.addArrangedSubview(tagView)
        }
    }
}
