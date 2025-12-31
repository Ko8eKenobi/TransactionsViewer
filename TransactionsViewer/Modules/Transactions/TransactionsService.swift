import Foundation

protocol TransactionsServiceProtocol {
    func prepareModel(product: ProductBySKU) -> TransactionsModel
}

final class TransactionsService: TransactionsServiceProtocol {
    private let currenciesService: CurrenciesServiceProtocol
    private var currencySymbols: [String: String]?
    private let graph: CurrenciesGraph

    init(currenciesService: CurrenciesServiceProtocol, graph: CurrenciesGraph) {
        self.currenciesService = currenciesService
        self.graph = graph
    }

    func prepareModel(product: ProductBySKU) -> TransactionsModel {
        fillCurrencySymbols(transactions: product.transactions)
        return buildModel(product: product)
    }
}

private extension TransactionsService {
    func fillCurrencySymbols(transactions: [Transaction]) {
        currencySymbols = currenciesService.fillCurrencySymbols(transactions: transactions)
    }

    func buildModel(product: ProductBySKU) -> TransactionsModel {
        let defaultCurrency = "GBP"
        let details: [TransactionsModel.Details] = product.transactions
            .compactMap { (transaction: Transaction) -> TransactionsModel.Details? in
                let local = transaction.amount
                let code = transaction.currency.uppercased()
                let symbol = currencySymbols?[code] ?? "?"

                guard
                    let currency =
                        (code == defaultCurrency ? 1 : currenciesService.calcRate(graph: graph, from: code, to: defaultCurrency))
                else {
                    return nil
                }

                let gbp = (local * currency).rounded(scale: 1)
                return TransactionsModel.Details(
                    currencySymbol: symbol,
                    localCurrency: local,
                    gbpCurrency: gbp
                )
            }
        let total = details.reduce(0) { $0 + ($1.gbpCurrency ?? 0) }
        return TransactionsModel(sku: product.sku, total: total, details: details)
    }
}
