import XCTest

@testable import TransactionsViewer

final class TransactionsFactoryTest: XCTestCase {
    private var sut: TransactionsFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TransactionsFactory()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFactoryReturnsProperVC() {
        // GIVEN

        let sku = "SKU-1"
        let transactions = [Transaction(amount: 10.5, currency: "USD", sku: sku)]
        let product = ProductBySKU(sku: sku, transactions: transactions)
        let graph = CurrenciesGraph()

        // WHEN
        let vc = sut.create(product: product, graph: graph)

        // THEN
        XCTAssert(vc is TransactionsViewController)
        XCTAssertNotNil(vc.view)
    }
}
