//
//  ShimmerView.swift
//  XCur
//
//  Created by Виктор Иванов on 17.04.2025.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .overlay(
                GeometryReader { geometry in
                    Color.white
                        .opacity(0.6)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .white, .clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .rotationEffect(.degrees(70))
                                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                        )
                        .animation(
                            .linear(duration: 1.2).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
            )
            .onAppear {
                isAnimating = true
            }
            .frame(height: 60)
    }
}
