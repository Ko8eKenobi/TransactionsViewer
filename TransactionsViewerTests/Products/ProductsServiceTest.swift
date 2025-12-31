import XCTest

@testable import TransactionsViewer

final class ProductsServiceTest: XCTestCase {
    private var ds: DSStub!
    private var sut: ProductsService!

    final class DSStub: DataSourceProtocol {
        var storage: [String: Any] = [:]
        var loadCounter = 0
        func loadPlist<T>(path: String) -> T? {
            loadCounter += 1
            return storage[path] as? T
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        ds = DSStub()
        sut = ProductsService(dsService: ds)
    }

    override func tearDownWithError() throws {
        ds = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testGetProductsGroupedBySKU() throws {
        // GIVEN
        ds.storage["transactions"] = [
            ProductData(amount: "10.5", currency: "USD", sku: "A"),
            ProductData(amount: "5.3", currency: "USD", sku: "A"),
            ProductData(amount: "20.1", currency: "EUR", sku: "B"),
        ]
        var productsBySKU: [ProductBySKU] = []
        var products: [ProductModel] = []

        // WHEN
        productsBySKU = sut.getProductsBySKU()
        products = sut.getProducts(productsBySku: productsBySKU)

        // THEN
        XCTAssert(products.count == 2)
        XCTAssertEqual(products.first { $0.sku == "A" }?.count, 2)
        XCTAssertEqual(products.first { $0.sku == "B" }?.count, 1)
    }

    func testGetEmptyProducts() {
        // GIVEN
        ds.storage.removeAll()

        var productsBySKU: [ProductBySKU] = []
        var products: [ProductModel] = []

        // WHEN
        productsBySKU = sut.getProductsBySKU()
        products = sut.getProducts(productsBySku: productsBySKU)

        // THEN
        XCTAssertTrue(products.isEmpty)
    }

    func testGetInvalidProducts() {
        // GIVEN
        ds.storage["transactions"] = [
            ProductData(amount: "asd", currency: "USD", sku: "SKU-1"),
            ProductData(amount: "10.5", currency: "USD", sku: "SKU-2"),
        ]

        var productsBySKU: [ProductBySKU] = []
        var products: [ProductModel] = []

        // WHEN
        productsBySKU = sut.getProductsBySKU()
        products = sut.getProducts(productsBySku: productsBySKU)
        print(products)
        // THEN
        XCTAssertTrue(products.count == 1)
        XCTAssertTrue(products[0].sku == "SKU-2")
    }

    func testGetProductsLoadsFileFirstCallOnly() {
        // GIVEN
        ds.storage["transactions"] = [
            ProductData(amount: "10.5", currency: "USD", sku: "SKU-1")
        ]
        ds.storage["rates"] = [
            RatesData(from: "USD", rate: "10.5", to: "EUR")
        ]
        var productsBySKU: [ProductBySKU] = sut.getProductsBySKU()
        var products: [ProductModel] = []
        // WHEN

        ds.loadCounter = 0
        productsBySKU = sut.getProductsBySKU()
        products = sut.getProducts(productsBySku: productsBySKU)
        products = sut.getProducts(productsBySku: productsBySKU)
        products = sut.getProducts(productsBySku: productsBySKU)
        // THEN
        XCTAssertTrue(ds.loadCounter == 1)
        XCTAssertTrue(products[0].count == 1)
    }

    func testGetProductsIsOrderNeeded() {
        // GIVEN
        ds.storage["transactions"] = [
            ProductData(amount: "1", currency: "USD", sku: "A"),
            ProductData(amount: "2", currency: "EUR", sku: "B"),
            ProductData(amount: "3", currency: "USD", sku: "C"),
            ProductData(amount: "4", currency: "EUR", sku: "D"),
            ProductData(amount: "5", currency: "USD", sku: "E"),
        ]
        let expected: Set<String> = ["A", "B", "C", "D", "E"]

        let productsBySKU: [ProductBySKU] = sut.getProductsBySKU()
        var products: [ProductModel] = sut.getProducts(productsBySku: productsBySKU)

        products = sut.getProducts(productsBySku: productsBySKU)
        // WHEN
        let pairs = Set(products.map { $0.sku })
        XCTAssertEqual(pairs, expected)
    }
}
