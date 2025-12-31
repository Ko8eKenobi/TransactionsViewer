import UIKit

protocol ProductsViewControllerProtocol: AnyObject {
    func showProducts(_ model: [ProductModel])
}

final class ProductsViewController: UIViewController {
    private let presenter: ProductsPresenterProtocol
    private lazy var contentView = ProductsView()

    init(_ presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"

        contentView.onSelectedRow = { [weak self] index in
            self?.presenter.didSelectProduct(index: index)
        }
        presenter.viewDidLoad()
    }
}

extension ProductsViewController: ProductsViewControllerProtocol {
    func showProducts(_ model: [ProductModel]) {
        contentView.update(model)
    }
}
