//
//  CurrencyService.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation

// сервис для подтягивания данных с апи (через структурку и кложуру, чтобы был проще di без протоколов)

struct CurrencyService {
    let fetchRates: (String) async throws -> [CurrencyRate]
}

extension CurrencyService {
    static let live = CurrencyService(
        fetchRates: { base in
            let urlString = "https://api.exchangerate.host/latest?base=\(base)"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
            
            return decoded.rates.map { CurrencyRate(code: $0.key, rate: $0.value) }
                .sorted { $0.code < $1.code }
        }
    )
    
    static let mock = CurrencyService(
        fetchRates: { base in
            // замедлим для правдоподобия
            try await Task.sleep(nanoseconds: 300_000_000)
            
            return [
                CurrencyRate(code: "EUR", rate: 0.91),
                CurrencyRate(code: "JPY", rate: 134.2),
                CurrencyRate(code: "RUB", rate: 90.5),
                CurrencyRate(code: base, rate: 1.0) // базовая валюта
            ].sorted { $0.code < $1.code }
        }
    )
    
    private struct CurrencyRatesResponse: Decodable {
        let rates: [String: Double]
    }
}
