import XCTest

@testable import TransactionsViewer

final class ProductsPresenterTest: XCTestCase {
    var sut: ProductsPresenter!
    var viewController: ViewSpy!
    var router: RouterSpy!
    var service: ProductsServiceSpy!
    var factory: FactorySpy!
    var currencyService: CurrenciesServiceProtocol!

    final class ViewSpy: ProductsViewControllerProtocol {
        var stubProducts: [ProductModel] = []
        func showProducts(_ model: [ProductModel]) {
            stubProducts = model
        }
    }

    final class ProductsServiceSpy: ProductsServiceProtocol {
        var stubProducts: [ProductModel] = []
        var stubBySKU: [ProductBySKU] = []
        var stubRates: [RatesData] = []

        var requestedSKU: String!

        func getRates() -> [RatesData] {
            return stubRates
        }

        func getProductsBySKU() -> [TransactionsViewer.ProductBySKU] {
            return stubBySKU
        }

        func getProducts(productsBySku: [ProductBySKU]) -> [ProductModel] {
            return stubProducts
        }
    }

    final class RouterSpy: RouterProtocol {
        var pushedVC: UIViewController?

        func setRootVC(vc: UIViewController) {}
        func push(_ vc: UIViewController, animated: Bool) {
            pushedVC = vc
        }
    }

    final class FactorySpy: TransactionsFactoryProtocol {
        var stubVC = UIViewController()
        var requestedSKU: String!

        func create(product: ProductBySKU, graph: CurrenciesGraph) -> UIViewController {
            requestedSKU = product.sku
            return stubVC
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = ViewSpy()
        router = RouterSpy()
        service = ProductsServiceSpy()
        factory = FactorySpy()
        currencyService = CurrenciesService()
        sut = ProductsPresenter(router: router, productsService: service, factory: factory, currenciesService: currencyService)
        sut.viewController = viewController
    }

    override func tearDownWithError() throws {
        viewController = nil
        router = nil
        service = nil
        factory = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testShowProducts() throws {
        // GIVEN
        service.stubProducts = [ProductModel(count: 2, sku: "A")]

        // WHEN
        sut.viewDidLoad()

        // THEN
        XCTAssertEqual(viewController.stubProducts.count, 1)
        let first = try XCTUnwrap(viewController.stubProducts.first)
        XCTAssertEqual(first.sku, "A")
    }

    func testUsesCorrectSKUandPushesVC() {
        // GIVEN
        service.stubProducts = [
            ProductModel(count: 2, sku: "SKU-1"),
            ProductModel(count: 1, sku: "SKU-2"),
        ]
        service.stubBySKU = [
            ProductBySKU(
                sku: "SKU-2",
                transactions: [
                    Transaction(amount: 10, currency: "USD", sku: "SKU-2")
                ]
            )
        ]

        sut.viewDidLoad()

        // WHEN
        sut.didSelectProduct(index: 0)

        // THEN
        XCTAssertIdentical(router.pushedVC, factory.stubVC)
    }

    func testOutOfBoundsDoesNotPush() {
        // GIVEN
        service.stubProducts = [ProductModel(count: 4, sku: "SKU-1")]
        sut.viewDidLoad()

        // WHEN
        sut.didSelectProduct(index: 1)

        // THEN
        XCTAssertNil(router.pushedVC)
        XCTAssertNil(service.requestedSKU)
    }
}
