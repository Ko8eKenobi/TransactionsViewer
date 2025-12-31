import Foundation

protocol CurrenciesServiceProtocol {
    func getRatesGraph(rates: [RatesData]) -> CurrenciesGraph
    func fillCurrencySymbols(transactions: [Transaction]) -> [String: String]
    func calcRate(graph: CurrenciesGraph, from: String, to: String) -> Decimal?
}

final class CurrenciesService: CurrenciesServiceProtocol {

    func getRatesGraph(rates: [RatesData]) -> CurrenciesGraph {
        var graph: [String: [Graph]] = [:]

        for rate in rates {
            guard let currency = Decimal(string: rate.rate) else {
                continue
            }
            graph[rate.from, default: []].append(Graph(to: rate.to, rate: currency))
            if currency != 0 {
                graph[rate.to, default: []].append(Graph(to: rate.from, rate: 1 / currency))
            }
        }
        return graph
    }

    func fillCurrencySymbols(transactions: [Transaction]) -> [String: String] {
        Dictionary(
            uniqueKeysWithValues: Set(transactions.map { $0.currency.uppercased() })
                .map { ($0, currencySymbol(for: $0)) }
        )
    }

    func calcRate(graph: CurrenciesGraph, from: String, to: String) -> Decimal? {
        let from = from.uppercased(), to = to.uppercased()
        if from == to {
            return 1
        }
        var q: [(String, Decimal)] = [(from, 1)]
        var seen: Set<String> = [from]
        var i = 0
        while i < q.count {
            let (cur, acc) = q[i]
            i += 1
            guard let currency = graph[cur] else { continue }
            for e in currency where !seen.contains(e.to) {
                let next = acc * e.rate
                if e.to == to {
                    return next
                }
                seen.insert(e.to)
                q.append((e.to, next))
            }
        }
        return nil
    }

    private func currencySymbol(for code: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code.uppercased()
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.currencySymbol ?? code
    }
}
