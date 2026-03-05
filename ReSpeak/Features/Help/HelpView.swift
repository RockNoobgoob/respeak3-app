// HelpView.swift
// ReSpeak
// Created: 2026-03-05
//
// Stub screen for the Help tab. Replace body with real content once
// the help / FAQ feature is designed and specced.

import SwiftUI

// MARK: - HelpView

struct HelpView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BrandColors.surfaceVariant
                    .ignoresSafeArea()
                Text("Coming soon")
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
                    .font(BrandTypography.body)
            }
            .navigationTitle("Help")
        }
    }
}

// MARK: - Preview

#Preview {
    HelpView()
}
