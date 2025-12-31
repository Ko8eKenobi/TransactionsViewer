import XCTest

@testable import TransactionsViewer

final class TransactionsServiceTest: XCTestCase {
    private var sut: TransactionsService!
    private var ds: DSStub!
    private var cur: CurrenciesServiceStub!

    final class DSStub: DataSourceProtocol {
        var storage: [String: Any] = [:]
        private var loadCounter = 0
        func loadPlist<T>(path: String) -> T? where T: Decodable {
            loadCounter += 1
            return storage[path] as? T
        }
    }

    final class CurrenciesServiceStub: CurrenciesServiceProtocol {
        private var ratesGraph: CurrenciesGraph = [:]
        var symbols: [String: String] = [:]
        var rates: [String: Decimal] = [:]
        var calcCount = 0

        func getRatesGraph(rates: [RatesData]) -> CurrenciesGraph {
            return ratesGraph
        }

        func fillCurrencySymbols(transactions: [Transaction]) -> [String: String] {
            return symbols
        }

        func calcRate(graph: CurrenciesGraph, from: String, to: String) -> Decimal? {
            calcCount += 1
            let fromUp = from.uppercased()
            let toUp = to.uppercased()
            return rates["\(fromUp)-\(toUp)"]
        }

    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        cur = CurrenciesServiceStub()
        let graph = CurrenciesGraph()
        sut = TransactionsService(currenciesService: cur, graph: graph)
    }

    override func tearDownWithError() throws {
        ds = nil
        cur = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testConversionToGBProundedTo1Decimal() {
        // GIVEN
        cur.rates["USD-GBP"] = Decimal(1.25)
        cur.symbols = ["USD": "$", "GBP": "£"]

        let transactions = [
            Transaction(amount: 2, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "GBP", sku: "SKU-2"),
        ]
        let product = ProductBySKU(sku: "SKU-1", transactions: transactions)

        // WHEN
        let model = sut.prepareModel(product: product)

        // THEN
        XCTAssertEqual(model.details[0].currencySymbol, "$")
        XCTAssertEqual(model.details[0].localCurrency, 2)
        XCTAssertEqual(model.details[0].gbpCurrency, 2.5)
        XCTAssertEqual(model.details[1].gbpCurrency, 12.5)
        XCTAssertEqual(model.details[2].gbpCurrency, model.details[2].localCurrency)
        XCTAssertEqual(cur.calcCount, 2)
    }

    func testNoRatesFound() {
        // GIVEN
        cur.rates.removeAll()
        cur.symbols = ["USD": "$", "GBP": "£"]
        let transactions = [
            Transaction(amount: 2, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "USD", sku: "SKU-1"),
        ]
        let product = ProductBySKU(sku: "SKU-1", transactions: transactions)
        // WHEN
        let model = sut.prepareModel(product: product)

        // THEN
        XCTAssertTrue(model.details.isEmpty)
    }

    func testMissingCurrencySymbol() {
        // GIVEN
        cur.rates["USD-GBP"] = Decimal(1.25)
        cur.symbols.removeAll()
        let transactions = [
            Transaction(amount: 2, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "GBP", sku: "SKU-2"),
        ]
        let product = ProductBySKU(sku: "SKU-1", transactions: transactions)

        // WHEN
        let model = sut.prepareModel(product: product)

        // THEN
        XCTAssertEqual(model.details[0].currencySymbol, "?")
    }
}
