import UIKit

final class ProductCell: UITableViewCell {
    static let reuseId = "ProductCell"

    private let name: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let transactions: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()

    private func setupLayout() {
        backgroundColor = .systemBackground

        contentView.addSubview(name)
        contentView.addSubview(transactions)

        name.translatesAutoresizingMaskIntoConstraints = false
        transactions.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            transactions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transactions.centerYAnchor.constraint(equalTo: name.centerYAnchor),
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        transactions.text = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: ProductModel) {
        name.text = product.sku
        transactions.text = "\(product.count) transactions"
    }
}
