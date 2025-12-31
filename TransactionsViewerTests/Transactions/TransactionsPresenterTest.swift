import XCTest

@testable import TransactionsViewer

final class TransactionsPresenterTest: XCTestCase {
    private var sut: TransactionsPresenter!
    private var tService: TransactionsServiceSpy!
    private var vc: ViewControllerSpy!

    private var sku: String!
    private var transactions: [Transaction]!

    final class TransactionsServiceSpy: TransactionsServiceProtocol {
        var stubModel = TransactionsModel(sku: "", total: 0, details: [])
        var receivedSku: String!
        var receivedTransactions: [Transaction]!

        func prepareModel(product: ProductBySKU) -> TransactionsModel {
            receivedSku = product.sku
            receivedTransactions = product.transactions
            return stubModel
        }

    }

    final class ViewControllerSpy: TransactionsViewControllerProtocol {
        var model: TransactionsModel!
        func showTransactions(_ model: TransactionsModel) {
            self.model = model
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        sku = "SKU-1"
        transactions = [
            Transaction(amount: 2.5, currency: "USD", sku: "SKU-1"),
            Transaction(amount: 10, currency: "EUR", sku: "SKU-1"),
        ]
        let product = ProductBySKU(sku: sku, transactions: transactions)
        vc = ViewControllerSpy()
        tService = TransactionsServiceSpy()
        sut = TransactionsPresenter(transactionsService: tService, product: product)
        sut.viewController = vc
    }

    override func tearDownWithError() throws {
        sku = nil
        transactions = nil
        vc = nil
        tService = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testViewDidLoadProperModel() {
        // GIVEN
        tService.stubModel = TransactionsModel(
            sku: "SKU-1",
            total: 10,
            details: [
                TransactionsModel.Details(
                    currencySymbol: "$",
                    localCurrency: 2.5,
                    gbpCurrency: 5
                ),
                TransactionsModel.Details(
                    currencySymbol: "€",
                    localCurrency: 10,
                    gbpCurrency: 20
                ),
            ]
        )
        // WHEN
        sut.viewDidLoad()
        // THEN
        XCTAssertEqual(tService.receivedSku, "SKU-1")
        XCTAssertEqual(tService.receivedTransactions.count, 2)
        XCTAssertTrue(vc.model.sku == "SKU-1")
        XCTAssertTrue(vc.model.details.count == 2)
        XCTAssertTrue(vc.model.details[0].currencySymbol == "$")
    }
}
