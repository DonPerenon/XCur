//
//  RatesViewState.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import Foundation

struct RatesViewState: Equatable {
    var isLoading: Bool
    var baseCurrency: String
    var rates: [CurrencyRate]
    var errorMessage: String?
}

extension RatesViewState {
    static var initial: Self {
        Self(
            isLoading: false,
            baseCurrency: "USD",
            rates: [],
            errorMessage: nil
        )
    }
}
