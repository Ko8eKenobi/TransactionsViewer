import UIKit

protocol RouterProtocol {
    func setRootVC(vc: UIViewController)
    func push(_ vc: UIViewController, animated: Bool)
}
