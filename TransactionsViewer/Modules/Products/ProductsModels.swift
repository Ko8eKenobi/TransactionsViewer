import Foundation

struct ProductData: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct ProductModel {
    let count: Int
    let sku: String
}
