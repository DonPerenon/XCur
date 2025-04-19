//
//  RatesView.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import SwiftUI

struct RatesView: View {
    @StateObject var viewModel: RatesViewModel

    var body: some View {
        NavigationView {
            VStack {
                content
            }
            .navigationTitle("Rates")
            .searchable(text: Binding(
                get: { viewModel.state.searchQuery },
                set: { viewModel.handle(action: .setSearchQuery($0)) }
            ))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.handle(action: .setBaseCurrencySelectorPresented(true))
                    }) {
                        HStack(spacing: 4) {
                            Text(viewModel.state.baseCurrency)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.handle(action: .loadRates)
            }
            .sheet(isPresented: Binding(
                get: { viewModel.state.isSelectingBaseCurrency },
                set: { viewModel.handle(action: .setBaseCurrencySelectorPresented($0)) }
            )) {
                CurrencySelectionView(
                    title: "Select base currency",
                    currencies: viewModel.state.rates.map(\.code),
                    onSelect: { code in
                        viewModel.handle(action: .selectBaseCurrency(code))
                        viewModel.handle(action: .setBaseCurrencySelectorPresented(false))
                    }
                )
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.state.isLoading {
            loadingView
        } else if let error = viewModel.state.errorMessage {
            errorView(message: error)
        } else {
            ratesList
        }
    }

    private var loadingView: some View {
        VStack {
            ShimmerView()
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Text("Error")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var ratesList: some View {
        List(viewModel.state.filteredRates) { rate in
            HStack {
                Text(rate.code)
                    .font(.title3).bold()
                Spacer()
                Text(String(format: "%.2f", rate.rate))
                    .font(.title3)
            }
            .padding(.vertical, 7)
        }
    }
}

#Preview {
    RatesView(viewModel: RatesViewModel(service: .mock))
}
