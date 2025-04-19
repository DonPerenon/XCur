//
//  ConverterView.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import SwiftUI

struct ConverterView: View {
    @StateObject var viewModel: ConverterViewModel
    
    private let availableCurrencies = ["USD", "EUR", "JPY", "RUB"]
    
    var body: some View {
        ZStack {
            Color.clear // чтобы тап ловился
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            VStack(spacing: 24) {
                title
                
                amountInput
                
                currencySelectors
                
                convertButton
                
                resultView
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.handle(action: .loadCurrencies)
        }
    }

    private var title: some View {
        Text("Currency Converter")
            .font(.title2.bold())
            .padding(.top)
    }

    private var amountInput: some View {
        TextField("Enter amount", text: Binding(
            get: { viewModel.state.amount },
            set: { viewModel.handle(action: .setAmount($0)) }
        ))
        .keyboardType(.decimalPad)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
    }

    private var currencySelectors: some View {
        HStack(spacing: 16) {
            currencySelectorButton(
                title: "From",
                value: viewModel.state.fromCurrency,
                action: { viewModel.state.isSelectingFrom = true }
            )
            .sheet(isPresented: Binding(
                get: { viewModel.state.isSelectingFrom },
                set: { viewModel.handle(action: .openFromList($0)) }
            )) {
                CurrencySelectionView(
                    title: "Select base currency",
                    currencies: viewModel.state.availableCurrencies,
                    onSelect: {
                        viewModel.handle(action: .setFromCurrency($0))
                        viewModel.handle(action: .openFromList(false))
                    }
                )
            }

            currencySelectorButton(
                title: "To",
                value: viewModel.state.toCurrency,
                action: { viewModel.state.isSelectingTo = true }
            )
            .sheet(isPresented: Binding(
                get: { viewModel.state.isSelectingTo },
                set: { viewModel.handle(action: .openToList($0)) }
            )) {
                CurrencySelectionView(
                    title: "Select base currency",
                    currencies: viewModel.state.availableCurrencies,
                    onSelect: {
                        viewModel.handle(action: .setToCurrency($0))
                        viewModel.handle(action: .openToList(false))
                    }
                )
            }
        }
    }
    
    private func currencySelectorButton(title: String, value: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Button(action: action) {
                HStack {
                    Text(value)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        }
    }

    private func currencyPicker(label: String, selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Picker("", selection: selection) {
                ForEach(["USD", "EUR", "JPY", "RUB"], id: \.self) { currency in
                    Text(currency).tag(currency)
                }
            }
            .pickerStyle(.menu)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }

    private var convertButton: some View {
        Button(action: {
            viewModel.handle(action: .convert)
        }) {
            Text("Convert")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(viewModel.state.isLoading)
    }

    @ViewBuilder
    private var resultView: some View {
        ZStack {
            if viewModel.state.isLoading {
                ShimmerView()
                    .frame(height: 60)
                    .transition(.opacity)
                    .opacity(viewModel.state.isLoading ? 1 : 0)
            }
            
            if (viewModel.state.errorMessage != nil || viewModel.state.result != nil) {
                resultCard
                    .opacity(viewModel.state.isLoading ? 0 : 1)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.state.isLoading)
    }

    @ViewBuilder
    private var resultCard: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                if let error = viewModel.state.errorMessage {
                    Text("Error")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(error)
                        .font(.body)
                        .foregroundColor(.red)
                } else if let result = viewModel.state.result {
                    Text("Converted:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack {
                        Text(viewModel.state.amount + " " + viewModel.state.fromCurrency)
                            .font(.body)
                            .foregroundColor(.primary)
                            .onTapGesture {
                                UIPasteboard.general.string = viewModel.state.amount
                                viewModel.handle(action: .triggerCopyFeedback)
                            }

                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)

                        Text("\(String(format: "%.2f", result)) \(viewModel.state.toCurrency)")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }

            Spacer()

            if viewModel.state.errorMessage == nil, let result = viewModel.state.result {
                Button {
                    UIPasteboard.general.string = String(format: "%.2f", result)
                    viewModel.handle(action: .triggerCopyFeedback)
                    withAnimation { viewModel.state.copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { viewModel.state.copied = false }
                    }
                } label: {
                    Image(systemName: viewModel.state.copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .foregroundColor(viewModel.state.copied ? .green : .blue)
                }
            }
        }
        .padding()
        .background(
            viewModel.state.errorMessage == nil ?
                Color.green.opacity(0.1) :
                Color.red.opacity(0.1)
        )
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }



}

#Preview {
    ConverterView(viewModel: ConverterViewModel(service: .mock))
}
