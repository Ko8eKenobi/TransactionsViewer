import UIKit

protocol ProductsFactoryProtocol {
    func create() -> UIViewController?
}

final class ProductsFactory: ProductsFactoryProtocol {
    func create() -> UIViewController? {
        let dsService = DataSourceService(bundle: .main)
        let productsService = ProductsService(dsService: dsService)
        let router = ProductsRouter()
        let factory = TransactionsFactory()
        let currenciesService = CurrenciesService()
        let presenter = ProductsPresenter(
            router: router,
            productsService: productsService,
            factory: factory,
            currenciesService: currenciesService
        )
        let vc = ProductsViewController(presenter)
        presenter.viewController = vc
        router.setRootVC(vc: vc)

        return UINavigationController(rootViewController: vc)
    }
}
