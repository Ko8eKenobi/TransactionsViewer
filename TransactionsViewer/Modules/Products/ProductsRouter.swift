import UIKit

final class ProductsRouter: RouterProtocol {
    private weak var rootVC: UIViewController?

    func setRootVC(vc: UIViewController) {
        rootVC = vc
    }

    func push(_ vc: UIViewController, animated: Bool = true) {
        if let nav = rootVC?.navigationController {
            nav.pushViewController(vc, animated: animated)
        } else {
            rootVC?.present(vc, animated: animated)
        }
    }
}
