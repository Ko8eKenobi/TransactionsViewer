import UIKit

protocol TransactionsViewControllerProtocol: AnyObject {
    func showTransactions(_ model: TransactionsModel)
}

final class TransactionsViewController: UIViewController {
    private let presenter: TransactionsPresenterProtocol
    private lazy var contentView = TransactionsView()

    init(presenter: TransactionsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension TransactionsViewController: TransactionsViewControllerProtocol {
    func showTransactions(_ model: TransactionsModel) {
        title = "Transactions \(model.sku)"
        contentView.update(model)
    }
}
