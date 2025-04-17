//
//  ConverterViewModel.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import Foundation

@MainActor
final class ConverterViewModel: ViewModel {
    
    enum Action: Equatable {
        case setAmount(String)
        case setFromCurrency(String)
        case setToCurrency(String)
        case convert
    }

    @Published var state: ConverterViewState = .initial

    private let service: CurrencyService

    init(service: CurrencyService = .live) {
        self.service = service
    }

    func handle(action: Action) {
        switch action {
        case .setAmount(let value):
            state.amount = value

        case .setFromCurrency(let value):
            state.fromCurrency = value

        case .setToCurrency(let value):
            state.toCurrency = value

        case .convert:
            Task { await convert() }
        }
    }

    private func convert() async {
        state.isLoading = true
        state.errorMessage = nil
        state.result = nil

        guard let amount = Double(state.amount) else {
            state.errorMessage = "Invalid amount"
            state.isLoading = false
            return
        }

        do {
            let result = try await service.convert(
                state.fromCurrency,
                state.toCurrency,
                amount
            )
            state.result = result
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }
}
