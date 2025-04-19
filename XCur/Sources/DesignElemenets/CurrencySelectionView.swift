//
//  CurrencySelectionView.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import SwiftUI

struct CurrencySelectionView: View {
    let title: String
    let currencies: [String]
    let onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            List(filteredCurrencies, id: \.self) { currency in
                Button(action: {
                    onSelect(currency)
                    dismiss()
                }) {
                    Text(currency)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var filteredCurrencies: [String] {
        guard !searchText.isEmpty else { return currencies }
        return currencies.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
    }
}
