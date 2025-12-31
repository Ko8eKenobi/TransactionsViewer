import Foundation

extension Decimal {
    func rounded(scale: Int, roundingMode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var result = Decimal()
        var value = self
        NSDecimalRound(&result, &value, scale, roundingMode)
        return result
    }
}
