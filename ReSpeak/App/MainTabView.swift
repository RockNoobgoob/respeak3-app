// MainTabView.swift
// ReSpeak
// Created: 2026-03-05
//
// Root tab container shown to authenticated users. Hosts the four primary
// sections of the app: Practice, Report, Help, and Settings.

import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {

    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "mic.fill")
                }
                .tag(0)

            ReportView()
                .tabItem {
                    Label("Report", systemImage: "chart.bar.fill")
                }
                .tag(1)

            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(BrandColors.primary)
        .toolbarBackground(.white, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .overlay(alignment: .bottom) {
            tabBarTopDivider
        }
    }

    // MARK: - Tab Bar Divider

    /// A 1 pt hairline drawn at the top of the system tab bar area so the
    /// divider tracks the safe-area inset on all device sizes.
    private var tabBarTopDivider: some View {
        VStack(spacing: 0) {
            Spacer()
            BrandColors.border
                .frame(height: 1 / UIScreen.main.scale)
                .padding(.bottom, tabBarHeight)
        }
        .ignoresSafeArea(edges: .bottom)
        .allowsHitTesting(false)
    }

    /// Approximate system tab bar height (49 pt content + safe-area padding
    /// handled separately via ignoresSafeArea above).
    private var tabBarHeight: CGFloat { 49 }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
