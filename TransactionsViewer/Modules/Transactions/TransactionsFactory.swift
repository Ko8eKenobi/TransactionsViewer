import UIKit

protocol TransactionsFactoryProtocol {
    func create(product: ProductBySKU, graph: CurrenciesGraph) -> UIViewController
}
final class TransactionsFactory: TransactionsFactoryProtocol {
    func create(product: ProductBySKU, graph: CurrenciesGraph) -> UIViewController {
        let currenciesService = CurrenciesService()
        let transactionService = TransactionsService(currenciesService: currenciesService, graph: graph)
        let presenter = TransactionsPresenter(transactionsService: transactionService, product: product)
        let vc = TransactionsViewController(presenter: presenter)
        presenter.viewController = vc

        return vc
    }
}
