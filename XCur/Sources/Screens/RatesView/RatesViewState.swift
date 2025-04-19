//
//  RatesViewState.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation

import Foundation

struct RatesViewState: Equatable {
    var isLoading: Bool
    var baseCurrency: String
    var rates: [CurrencyRate]
    var filteredRates: [CurrencyRate]
    var errorMessage: String?
    var searchQuery: String
    var baseCurrencyOptions: [String]
    var isSelectingBaseCurrency: Bool
}

extension RatesViewState {
    static var initial: Self {
        Self(
            isLoading: false,
            baseCurrency: "USD",
            rates: [],
            filteredRates: [],
            errorMessage: nil,
            searchQuery: "",
            baseCurrencyOptions: ["USD", "EUR", "JPY", "RUB", "CNY", "GBP"],
            isSelectingBaseCurrency: false
        )
    }
}


