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
            .onAppear {
                viewModel.handle(action: .loadRates)
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
        List(viewModel.state.rates) { rate in
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
    RatesView(viewModel: RatesViewModel(service: .live))
}
