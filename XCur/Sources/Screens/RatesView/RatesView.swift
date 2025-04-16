//
//  RatesView.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import SwiftUI

struct RatesView: View {
    @StateObject private var viewModel = RatesViewModel()

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Rates")
                .onAppear {
                    viewModel.handle(action: .loadRates)
                }
        }
    }

    // MARK: - Main content switcher

    @ViewBuilder
    private var content: some View {
        switchContent(
            isLoading: viewModel.state.isLoading,
            errorMessage: viewModel.state.errorMessage,
            rates: viewModel.state.rates
        )
    }

    // MARK: - Switch by state

    @ViewBuilder
    private func switchContent(
        isLoading: Bool,
        errorMessage: String?,
        rates: [CurrencyRate]
    ) -> some View {
        if isLoading {
            loadingView
        } else if let error = errorMessage {
            errorView(message: error)
        } else {
            ratesList(rates: rates)
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading rates...")
            Spacer()
        }
    }

    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }

    private func ratesList(rates: [CurrencyRate]) -> some View {
        List(rates) { rate in
            HStack {
                Text(rate.code)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", rate.rate))
                    .font(.subheadline)
            }
        }
    }
}
