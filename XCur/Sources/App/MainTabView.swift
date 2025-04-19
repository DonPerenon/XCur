//
//  MainTabView.swift
//  XCur
//
//  Created by Виктор Иванов on 16.04.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            let ratesViewModel = RatesViewModel(service: CurrencyService.live)
            RatesView(viewModel: ratesViewModel)
                .tabItem {
                    Label("Rates", systemImage: "list.bullet.rectangle")
                }

            let converterViewModel = ConverterViewModel(service: CurrencyService.live)
            ConverterView(viewModel: converterViewModel)
                .tabItem {
                    Label("Convert", systemImage: "arrow.2.squarepath")
                }
        }
    }
}

#Preview {
    MainTabView()
}
