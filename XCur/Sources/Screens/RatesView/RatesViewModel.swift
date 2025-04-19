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
    private var hasLoadedOnce = false

    init(service: CurrencyService = .live) {
        self.service = service
    }

    func handle(action: Action) {
        switch action {
        case .loadRates:
            guard !hasLoadedOnce else { return }
            hasLoadedOnce = true
            Task { await loadRates() }

        case .updateBaseCurrency(let newBase):
            state.baseCurrency = newBase
            handle(action: .loadRates)
            
        case .setSearchQuery(let query):
            state.searchQuery = query
            updateFilteredRates()

        case .selectBaseCurrency(let newBase):
            state.baseCurrency = newBase
            state.rates = []
            hasLoadedOnce = false
            handle(action: .loadRates)
            
        case .setBaseCurrencySelectorPresented(let isPresented):
            state.isSelectingBaseCurrency = isPresented
        }
    }

    private func loadRates() async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            let fetched = try await service.fetchRates(state.baseCurrency)
            state.rates = fetched
            updateFilteredRates()
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }
    
    private func updateFilteredRates() {
        if state.searchQuery.isEmpty {
            state.filteredRates = state.rates
        } else {
            state.filteredRates = state.rates.filter {
                $0.code.lowercased().contains(state.searchQuery.lowercased())
            }
        }
    }
    
    enum Action: Equatable {
        case loadRates
        case updateBaseCurrency(String)
        case setSearchQuery(String)
        case selectBaseCurrency(String)
        case setBaseCurrencySelectorPresented(Bool)
    }
}
