import UIKit

final class TransactionsView: UIView {
    var model: TransactionsModel?

    let totalLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()

    let currenciesTable: UITableView = {
        let table = UITableView()
        table.isOpaque = true
        table.allowsSelection = false
        return table
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ model: TransactionsModel) {
        self.model = model
        totalLabel.text = "Total: \(model.total) £"
    }
}
extension TransactionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.details.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseId, for: indexPath) as? TransactionCell
        cell?.configure(with: model?.details[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
private extension TransactionsView {
    func setupLayout() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        backgroundColor = .white
        currenciesTable.backgroundColor = .systemBackground
        currenciesTable.dataSource = self
        addSubview(totalLabel)
        addSubview(currenciesTable)
    }

    func setupConstraints() {
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        currenciesTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: 44),

            currenciesTable.topAnchor.constraint(equalTo: totalLabel.bottomAnchor),
            currenciesTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            currenciesTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            currenciesTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        currenciesTable.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseId)
    }
}
