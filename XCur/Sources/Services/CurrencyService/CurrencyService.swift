//
//  CurrencyService.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation

struct CurrencyService {
    let fetchRates: (String) async throws -> [CurrencyRate]
    let convert: (String, String, Double) async throws -> Double
}

extension CurrencyService {
    static let live = CurrencyService(
        fetchRates: { base in
            let urlString = "https://open.er-api.com/v6/latest/\(base)"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
            
            guard decoded.result == "success" else {
                throw URLError(.cannotParseResponse)
            }
            
            return decoded.rates.map { CurrencyRate(code: $0.key, rate: $0.value) }
                .sorted { $0.code < $1.code }
        },
        convert: { from, to, amount in
            try await Task.sleep(nanoseconds: 1_500_000_000) // искусственно замедляю запрос, чтобы полюбоваться шиммером в ConvertView:)
            
            let url = URL(string: "https://open.er-api.com/v6/latest/\(from)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
            guard decoded.result == "success" else {
                throw URLError(.cannotParseResponse)
            }
            
            guard let rate = decoded.rates[to] else {
                throw URLError(.badServerResponse)
            }
            
            return amount * rate
        }
    )
    
    static let mock = CurrencyService(
        fetchRates: { base in
            try await Task.sleep(nanoseconds: 300_000_000)
            return [
                CurrencyRate(code: "EUR", rate: 0.91),
                CurrencyRate(code: "JPY", rate: 134.2),
                CurrencyRate(code: "RUB", rate: 90.5),
                CurrencyRate(code: base, rate: 1.0)
            ].sorted { $0.code < $1.code }
        },
        convert: { from, to, amount in
            try await Task.sleep(nanoseconds: 200_000_000)
            return amount * 0.91 // magic numbers - это плохо, но с моками можно творить все, что хочется)))
        }
    )

    private struct CurrencyRatesResponse: Decodable {
        let result: String
        let rates: [String: Double]
    }
}

