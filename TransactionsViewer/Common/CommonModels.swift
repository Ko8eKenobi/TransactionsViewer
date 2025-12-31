import Foundation

struct Transaction {
    let amount: Decimal
    let currency: String
    let sku: String
}

struct ProductBySKU {
    let sku: String
    let transactions: [Transaction]
}
