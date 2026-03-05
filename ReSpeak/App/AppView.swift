// AppView.swift
// ReSpeak
//
// Root routing view. Uses AuthService (Supabase session) as the source of
// truth for authentication state. Unauthenticated users see LoginView;
// authenticated users see MainTabView.
//
// The onboarding flag (@AppStorage) is intentionally removed — auth is now
// the single routing signal. If a dedicated onboarding flow is added later,
// add a separate `hasCompletedOnboarding` check inside the authenticated branch.

import SwiftUI

// MARK: - AppView

struct AppView: View {

    @EnvironmentObject private var auth: AuthService

    var body: some View {
        Group {
            if auth.isAuthenticated {
                MainTabView()
                    .transition(.opacity)
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: auth.isAuthenticated)
    }
}

// MARK: - Preview

#Preview("Unauthenticated") {
    AppView()
        .environmentObject(AuthService())
}
