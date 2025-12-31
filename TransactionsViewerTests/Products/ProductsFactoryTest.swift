import XCTest

@testable import TransactionsViewer

final class ProductsFactoryTest: XCTestCase {
    private var sut: ProductsFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ProductsFactory()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFactoryReturnsProperVC() {
        // GIVEN

        // WHEN
        let vc = sut.create()

        // THEN
        XCTAssert(vc is UINavigationController)
        XCTAssertNotNil(vc)
    }
}
