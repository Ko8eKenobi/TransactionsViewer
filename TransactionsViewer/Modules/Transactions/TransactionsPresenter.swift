protocol TransactionsPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class TransactionsPresenter: TransactionsPresenterProtocol {
    weak var viewController: TransactionsViewControllerProtocol?
    private let transactionsService: TransactionsServiceProtocol
    private let product: ProductBySKU

    init(transactionsService: TransactionsServiceProtocol, product: ProductBySKU) {
        self.transactionsService = transactionsService
        self.product = product
    }

    func viewDidLoad() {
        let model = transactionsService.prepareModel(product: product)
        viewController?.showTransactions(model)
    }
}
