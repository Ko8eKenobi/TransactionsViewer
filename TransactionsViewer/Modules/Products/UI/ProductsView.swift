import UIKit

final class ProductsView: UIView {
    private var model: [ProductModel] = []
    private let productsTable: UITableView = {
        let table = UITableView()
        return table
    }()

    var onSelectedRow: ((Int) -> Void)?

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ model: [ProductModel]) {
        self.model = model
        productsTable.reloadData()
    }
}

private extension ProductsView {
    func setupLayout() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        backgroundColor = .white
        productsTable.backgroundColor = .systemBackground
        productsTable.dataSource = self
        productsTable.delegate = self
        addSubview(productsTable)
    }

    func setupConstraints() {
        productsTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productsTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            productsTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            productsTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            productsTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        productsTable.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseId)
    }
}

extension ProductsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as? ProductCell
        cell?.configure(with: model[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // presenter.didSelectProduct(index: indexPath.row)
        onSelectedRow?(indexPath.row)
    }
}
