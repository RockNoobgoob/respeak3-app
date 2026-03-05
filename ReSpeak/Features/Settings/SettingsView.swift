// SettingsView.swift
// ReSpeak
// Created: 2026-03-05
//
// Stub screen for the Settings tab. Replace body with real content once
// the settings feature is designed and specced.

import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BrandColors.surfaceVariant
                    .ignoresSafeArea()
                Text("Coming soon")
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
                    .font(BrandTypography.body)
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
