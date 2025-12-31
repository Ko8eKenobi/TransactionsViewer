import Foundation

protocol ProductsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectProduct(index: Int)
}

typealias CurrenciesGraph = [String: [Graph]]

struct Graph {
    let to: String
    let rate: Decimal
}
final class ProductsPresenter: ProductsPresenterProtocol {
    weak var viewController: ProductsViewControllerProtocol?
    private let router: RouterProtocol
    private let productsService: ProductsServiceProtocol
    private let factory: TransactionsFactoryProtocol
    private let currenciesService: CurrenciesServiceProtocol

    private var productsBySku: [ProductBySKU] = []

    private var graph: CurrenciesGraph = [:]

    init(
        router: RouterProtocol,
        productsService: ProductsServiceProtocol,
        factory: TransactionsFactoryProtocol,
        currenciesService: CurrenciesServiceProtocol
    ) {
        self.productsService = productsService
        self.router = router
        self.factory = factory
        self.currenciesService = currenciesService
    }

    func viewDidLoad() {
        let rates: [RatesData] = productsService.getRates()
        productsBySku = productsService.getProductsBySKU()
        let models = productsService.getProducts(productsBySku: productsBySku)
        graph = currenciesService.getRatesGraph(rates: rates)
        viewController?.showProducts(models)
    }

    func didSelectProduct(index: Int) {
        guard productsBySku.indices.contains(index) else {
            return
        }

        let product = productsBySku[index]
        let vc = factory.create(product: product, graph: graph)
        router.push(vc, animated: true)
    }
}
