// ReportView.swift
// ReSpeak
// Created: 2026-03-05
//
// Stub screen for the Report tab. Replace body with real content once
// the reporting feature is designed and specced.

import SwiftUI

// MARK: - ReportView

struct ReportView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BrandColors.surfaceVariant
                    .ignoresSafeArea()
                Text("Coming soon")
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
                    .font(BrandTypography.body)
            }
            .navigationTitle("Report")
        }
    }
}

// MARK: - Preview

#Preview {
    ReportView()
}
