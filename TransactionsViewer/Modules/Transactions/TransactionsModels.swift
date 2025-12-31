import Foundation

struct RatesData: Decodable {
    let from: String
    let rate: String
    let to: String
}

struct TransactionsModel {
    let sku: String
    let total: Decimal
    var details: [Details]

    struct Details {
        let currencySymbol: String
        let localCurrency: Decimal?
        let gbpCurrency: Decimal?
    }
}
