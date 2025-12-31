import Foundation

protocol ProductsServiceProtocol {
    func getRates() -> [RatesData]
    func getProductsBySKU() -> [ProductBySKU]
    func getProducts(productsBySku: [ProductBySKU]) -> [ProductModel]
}

final class ProductsService: ProductsServiceProtocol {
    private let dsService: DataSourceProtocol

    init(dsService: DataSourceProtocol) {
        self.dsService = dsService
    }

    func getRates() -> [RatesData] {
        let file = "rates"
        guard let loadedData: [RatesData] = dsService.loadPlist(path: file) else {
            return []
        }
        return loadedData
    }

    func getProductsBySKU() -> [ProductBySKU] {
        let file = "transactions"
        guard let data: [ProductData] = dsService.loadPlist(path: file) else {
            return []
        }

        let transactions: [Transaction] = data.compactMap { (product: ProductData) -> Transaction? in
            guard let amount = Decimal(string: product.amount) else {
                return nil
            }
            return Transaction(amount: amount, currency: product.currency, sku: product.sku)
        }

        return Dictionary(grouping: transactions) { $0.sku }
            .map { ProductBySKU(sku: $0.key, transactions: $0.value) }
    }

    func getProducts(productsBySku: [ProductBySKU]) -> [ProductModel] {
        productsBySku.map { ProductModel(count: $0.transactions.count, sku: $0.sku) }
    }
}
