//
//  ConverterViewModel.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import SwiftUI

@MainActor
final class ConverterViewModel: ViewModel {
    
    enum Action: Equatable {
        case setAmount(String)
        case setFromCurrency(String)
        case setToCurrency(String)
        case convert
        case openFromList(Bool)
        case openToList(Bool)
        case triggerCopyFeedback
        case loadCurrencies
        case didLoadCurrencies([String])
    }

    @Published var state: ConverterViewState = .initial

    private let service: CurrencyService

    init(service: CurrencyService = .live) {
        self.service = service
    }

    func handle(action: Action) {
        switch action {
        case .setAmount(let value):
            withAnimation(.easeInOut) {
                guard state.amount != value else { return }
                state.amount = value
                state.result = nil
            }

        case .setFromCurrency(let value):
            withAnimation(.easeInOut) {
                state.fromCurrency = value
                state.result = nil
            }

        case .setToCurrency(let value):
            withAnimation(.easeInOut) {
                state.toCurrency = value
                state.result = nil
            }

        case .convert:
            Task { await convert() }
            
        case .openFromList(let flag):
            state.isSelectingFrom = flag

        case .openToList(let flag):
            state.isSelectingTo = flag
            
        case .triggerCopyFeedback:
            triggerCopyFeedback()
            
        case .loadCurrencies:
               Task {
                   do {
                       let rates = try await service.fetchRates("USD")
                       let codes = rates.map(\.code).sorted()
                       handle(action: .didLoadCurrencies(codes))
                   } catch {
                       state.errorMessage = error.localizedDescription
                   }
               }

           case .didLoadCurrencies(let codes):
               state.availableCurrencies = codes
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
    
    private func triggerCopyFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
