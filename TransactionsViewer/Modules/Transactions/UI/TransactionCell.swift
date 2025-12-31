import UIKit

final class TransactionCell: UITableViewCell {
    static let reuseId = "TransactionCell"

    private let local: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()

    private let gbp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()

    private func setupLayout() {
        backgroundColor = .systemBackground

        contentView.addSubview(local)
        contentView.addSubview(gbp)

        local.translatesAutoresizingMaskIntoConstraints = false
        gbp.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            local.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            local.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            local.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            gbp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gbp.centerYAnchor.constraint(equalTo: local.centerYAnchor),
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        local.text = nil
        gbp.text = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TransactionsModel.Details?) {
        let localS = model?.localCurrency.map { "\($0)" } ?? ""
        let gbpS = model?.gbpCurrency.map { "\($0)" } ?? ""
        let symbolS = model?.currencySymbol ?? ""

        local.text = "\(localS) \(symbolS)"
        gbp.text = "\(gbpS) £"
    }
}
