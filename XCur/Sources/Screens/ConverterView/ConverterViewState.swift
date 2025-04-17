//
//  ConverterViewState.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import Foundation

struct ConverterViewState: Equatable {
    var amount: String
    var fromCurrency: String
    var toCurrency: String
    var result: Double?
    var isLoading: Bool
    var errorMessage: String?
}

extension ConverterViewState {
    static var initial: Self {
        Self(
            amount: "1.0",
            fromCurrency: "USD",
            toCurrency: "EUR",
            result: nil,
            isLoading: false,
            errorMessage: nil
        )
    }
}
