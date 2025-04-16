//
//  CurrencyService.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import SwiftUI

@MainActor
final class RatesViewModel: ViewModel {

    @Published var state: RatesViewState = .initial

    private let service: CurrencyService

    init(service: CurrencyService = .live) {
        self.service = service
    }

    func handle(action: Action) {
        switch action {
        case .loadRates:
            Task { await loadRates() }

        case .updateBaseCurrency(let newBase):
            state.baseCurrency = newBase
            handle(action: .loadRates)
        }
    }

    private func loadRates() async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            let fetched = try await service.fetchRates(state.baseCurrency)
            state.rates = fetched
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }
    
    enum Action: Equatable {
        case loadRates
        case updateBaseCurrency(String)
    }
}
