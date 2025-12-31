import Foundation

protocol DataSourceProtocol {
    func loadPlist<T: Decodable>(path: String) -> T?
}

final class DataSourceService: DataSourceProtocol {
    private let bundle: Bundle
    private let decoder = PropertyListDecoder()

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func loadPlist<T: Decodable>(path: String) -> T? {
        guard let url = bundle.url(forResource: path, withExtension: "plist") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
}
